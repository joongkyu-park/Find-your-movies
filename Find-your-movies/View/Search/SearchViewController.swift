//
//  SearchViewController.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/13.
//

import UIKit

import Reusable
import RxSwift
import RxCocoa
import SnapKit

final class SearchViewController: UIViewController {
    // MARK: - Constants
    private let collectionViewMinimumLineSpacing: CGFloat = 10.0
    // MARK: - UI
    private let searchBar = UISearchBar()
    private let noResultMarkLabel = UILabel()
    private let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    // MARK: - Instances
    private let alertManager = AlertManager()
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setUpNavigationBar()
        setUpViewController()
        setUpSearchBar()
        setUpNoResultMarkLabel()
        setUpMoviesCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchFavoriteMovies()
        moviesCollectionView.reloadData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
}

// MARK: - Set up
extension SearchViewController {
    // MARK: - View Controller
    private func addSubviews() {
        view.addSubview(moviesCollectionView)
        view.addSubview(noResultMarkLabel)
        view.bringSubviewToFront(noResultMarkLabel)
    }
    private func setUpViewController() {
        setStyleOfViewController()
    }
    private func setStyleOfViewController() {
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
    }
    // MARK: - Navigation Bar
    private func setUpNavigationBar() {
        navigationItem.titleView = searchBar
    }
    // MARK: - Search Bar
    private func setUpSearchBar() {
        configureSearchBar()
        setStyleOfSearchBar()
    }
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    private func setStyleOfSearchBar() {
        searchBar.placeholder = Constants.Text.searchBar
        searchBar.searchBarStyle = .minimal
    }
    // MARK: - No Result Mark Label
    private func setUpNoResultMarkLabel() {
        setStyleOfNoResultMarkLabel()
        setConstraintsOfNoResultMarkLabel()
        bindNoResultMarkLabel()
    }
    private func setStyleOfNoResultMarkLabel() {
        noResultMarkLabel.text = Constants.Text.noResultLabel
        noResultMarkLabel.font = UIFont(name: Constants.FontName.appleSDGothicNeoRegular, size: 20)
        noResultMarkLabel.textColor = .black
        noResultMarkLabel.isHidden = false
    }
    private func setConstraintsOfNoResultMarkLabel() {
        noResultMarkLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    private func bindNoResultMarkLabel() {
        viewModel.moviesSubject
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if $0.isEmpty {
                    self.noResultMarkLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Movies Collection View
    private func setUpMoviesCollectionView() {
        setStyleOfMoviesCollectionView()
        setConstraintsOfMoviesCollectionView()
        configureMoviesCollectionView()
        bindMoviesCollectionView()
    }
    private func setStyleOfMoviesCollectionView() {
        moviesCollectionView.backgroundColor = .white
    }
    private func setConstraintsOfMoviesCollectionView() {
        moviesCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func configureMoviesCollectionView() {
        moviesCollectionView.register(cellType: MoviesCollectionViewCell.self)
        moviesCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTouchGesture(_:)))
        gesture.cancelsTouchesInView = false
        moviesCollectionView.addGestureRecognizer(gesture)
    }
    private func bindMoviesCollectionView() {
        viewModel.moviesSubject
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                if false == $0.isEmpty {
                    self.noResultMarkLabel.isHidden = true
                }
            })
            .bind(to: moviesCollectionView.rx.items(cellIdentifier: MoviesCollectionViewCell.reuseIdentifier, cellType: MoviesCollectionViewCell.self)) { [weak self] index, movie, cell in
                guard let self = self else { return }
                cell.setContents(poster: movie.poster, title: movie.title, year: movie.year, type: movie.type)
                if self.viewModel.isFavoriteMovie(at: index) {
                    cell.setFavoriteMarkOn()
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Gesture
extension SearchViewController {
    @objc func handleTouchGesture(_ gesture: UITapGestureRecognizer) {
        searchBar.endEditing(true)
    }
}

// MARK: - Collection View Delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - collectionViewMinimumLineSpacing,
                      height: collectionView.bounds.width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewMinimumLineSpacing * 2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.movie(at: indexPath.row) else { return }
        if viewModel.isFavoriteMovie(at: indexPath.row) {
            let alertForFavoriteOff = alertManager.alertForFavoriteOff(viewModel: viewModel, title: movie.title, index: indexPath.row) { [weak self] in
                guard let self = self else { return }
                guard let cell = self.moviesCollectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as? MoviesCollectionViewCell else { return }
                cell.setFavoriteMarkOff()
            }
            present(alertForFavoriteOff, animated: true, completion: nil)
            return
        }
        let alertForFavoriteOn = alertManager.alertForFavoriteOn(viewModel: viewModel, title: movie.title, index: indexPath.row) { [weak self] in
            guard let self = self else { return }
            guard let cell = self.moviesCollectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as? MoviesCollectionViewCell else { return }
            cell.setFavoriteMarkOn()
        }
        present(alertForFavoriteOn, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.moviesCount() - 1 {
            viewModel.fetchMovies()
        }
    }
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        moviesCollectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .init(rawValue: 0), animated: true)
        viewModel.fetchMovies(from: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
