//
//  FavoriteViewController.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/13.
//

import UIKit

import Reusable
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class FavoriteViewController: UIViewController {
    // MARK: - Constants
    private let collectionViewMinimumLineSpacing: CGFloat = 10.0
    // MARK: - UI
    private let noFavoriteMoviesMarkLabel = UILabel()
    private let favoriteMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    // MARK: - Instances
    private let alertManager = AlertManager()
    private var viewModel = FavoriteViewModel()
    private var dataSource: FavoriteMoviesCollectionViewDataSources!
    private let disposeBag = DisposeBag()
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setUpNavigationBar()
        setUpViewController()
        setUpNoFavoriteMoviesMarkLabel()
        setUpFavoriteMoviesCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchFavoriteMovies()
    }
}

// MARK: - Set up
extension FavoriteViewController {
    // MARK: - View Controller
    private func addSubviews() {
        view.addSubview(favoriteMoviesCollectionView)
        view.addSubview(noFavoriteMoviesMarkLabel)
        view.bringSubviewToFront(noFavoriteMoviesMarkLabel)
    }
    private func setUpViewController() {
        setStyleOfViewController()
    }
    private func setStyleOfViewController() {
        view.backgroundColor = .white
    }
    // MARK: - Navigation Bar
    private func setUpNavigationBar() {
        navigationItem.title = Constants.Text.titleForFavoriteViewController
    }
    // MARK: - No FavoriteMovies Mark Label
    private func setUpNoFavoriteMoviesMarkLabel() {
        setStyleOfNoFavoriteMoviesMarkLabel()
        setConstraintsOfNoFavoriteMoviesMarkLabel()
        bindNoFavoriteMoviesMarkLabel()
    }
    private func setStyleOfNoFavoriteMoviesMarkLabel() {
        noFavoriteMoviesMarkLabel.text = Constants.Text.noFavoriteMoviesLabel
        noFavoriteMoviesMarkLabel.font = UIFont(name: Constants.FontName.appleSDGothicNeoRegular, size: 20)
        noFavoriteMoviesMarkLabel.textColor = .black
    }
    private func setConstraintsOfNoFavoriteMoviesMarkLabel() {
        noFavoriteMoviesMarkLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    private func bindNoFavoriteMoviesMarkLabel() {
        viewModel.favoriteMoviesSubject
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if $0.isEmpty {
                    self.noFavoriteMoviesMarkLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Favorite Movies Collection View
    private func setUpFavoriteMoviesCollectionView() {
        setStyleOfFavoriteMoviesCollectionView()
        setConstraintsOfFavoriteMoviesCollectionView()
        configureFavoriteMoviesCollectionView()
        bindFavoriteMoviesCollectionView()
    }
    private func setStyleOfFavoriteMoviesCollectionView() {
        favoriteMoviesCollectionView.backgroundColor = .white
    }
    private func setConstraintsOfFavoriteMoviesCollectionView() {
        favoriteMoviesCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func configureFavoriteMoviesCollectionView() {
        favoriteMoviesCollectionView.register(cellType: MoviesCollectionViewCell.self)
        favoriteMoviesCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        setFavoriteMoviesCollectionViewDataSource()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        favoriteMoviesCollectionView.addGestureRecognizer(gesture)
    }
    private func setFavoriteMoviesCollectionViewDataSource() {
        let dataSource = FavoriteMoviesCollectionViewDataSources(viewModel: &viewModel)
        self.dataSource = dataSource
    }
    private func bindFavoriteMoviesCollectionView() {
        viewModel.favoriteMoviesSubject
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                if false == $0.isEmpty {
                    self.noFavoriteMoviesMarkLabel.isHidden = true
                }
            })
            .bind(to: favoriteMoviesCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - Gesture
extension FavoriteViewController {
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let indexPath = favoriteMoviesCollectionView.indexPathForItem(at: gesture.location(in: favoriteMoviesCollectionView)) else { return }
            favoriteMoviesCollectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            favoriteMoviesCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: favoriteMoviesCollectionView))
        case .ended:
            favoriteMoviesCollectionView.endInteractiveMovement()
        default:
            favoriteMoviesCollectionView.cancelInteractiveMovement()
        }
    }
}

// MARK: - Collection View Delegate
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - collectionViewMinimumLineSpacing,
                      height: collectionView.bounds.width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewMinimumLineSpacing * 2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.movie(at: indexPath.row) else { return }
        let alertForFavoriteOff = alertManager.alertForFavoriteOff(viewModel: viewModel, title: movie.title, index: indexPath.row) { [weak self] in
            guard let self = self else { return }
            self.viewModel.makeFavoriteOff(at: indexPath.row)
        }
        present(alertForFavoriteOff, animated: true, completion: nil)
    }
}
