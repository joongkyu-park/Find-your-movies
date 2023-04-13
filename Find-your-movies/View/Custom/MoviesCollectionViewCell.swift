//
//  MoviesCollectionViewCell.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/14.
//

import UIKit

import Reusable
import RxSwift
import SnapKit

final class MoviesCollectionViewCell: UICollectionViewCell, Reusable {
    // MARK: - Constants
    private let cellCornerRadius: CGFloat = 10.0
    // MARK: - UI
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let typeLabel = UILabel()
    private let favoriteMarkImageView = UIImageView()
    // MARK: - Instances
    private var disposeBag = DisposeBag()
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setUpCell()
        setUpPosterImageView()
        setUpTitleLabel()
        setUpYearLabel()
        setUpTypeLabel()
        setUpFavoriteMarkImageView()
    }
    required init?(coder: NSCoder) {
        fatalError("Not implemented required init?(coder: NSCoder)")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        favoriteMarkImageView.isHidden = true
        disposeBag = DisposeBag()
    }
}

// MARK: - Set up
extension MoviesCollectionViewCell {
    // MARK: - Cell
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(posterImageView)
        contentView.addSubview(yearLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(favoriteMarkImageView)
    }
    private func setUpCell() {
        setStyleOfCell()
    }
    private func setStyleOfCell() {
        backgroundColor = Constants.Color.base
        contentView.layer.cornerRadius = cellCornerRadius
        contentView.layer.masksToBounds = true
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cellCornerRadius).cgPath
        layer.cornerRadius = cellCornerRadius
    }
    // MARK: - Poster Image View
    private func setUpPosterImageView() {
        setStyleOfPosterImageView()
        setConstraintsOfPosterImageView()
    }
    private func setStyleOfPosterImageView() {
        posterImageView.backgroundColor = .lightGray
    }
    private func setConstraintsOfPosterImageView() {
        posterImageView.snp.makeConstraints {
            $0.top.left.right.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(3.0 / 2.0)
        }
    }
    private func setPosterImageView(from url: String) {
        posterImageView.loadImage(from: url)
    }
    // MARK: - Title Label
    private func setUpTitleLabel() {
        setStyleOfTitleLabel()
        setConstraintsOfTitleLabel()
    }
    private func setStyleOfTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: Constants.FontName.appleSDGothicNeoBold, size: 18)
        titleLabel.textColor = .white
    }
    private func setConstraintsOfTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(10)
            $0.left.right.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(self).priority(249)
        }
    }
    private func setTitleLabel(to title: String) {
        titleLabel.text = title
    }
    // MARK: - Year Label
    private func setUpYearLabel() {
        setStyleOfYearLabel()
        setConstraintsOfYearLabel()
    }
    private func setStyleOfYearLabel() {
        yearLabel.textAlignment = .center
        yearLabel.numberOfLines = 1
        yearLabel.font = UIFont(name: Constants.FontName.appleSDGothicNeoRegular, size: 12)
        yearLabel.textColor = .white
    }
    private func setConstraintsOfYearLabel() {
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    private func setYearLabel(to year: String) {
        yearLabel.text = year
    }
    // MARK: - Type Label
    private func setUpTypeLabel() {
        setStyleOfTypeLabel()
        setConstraintsOfTypeLabel()
    }
    private func setStyleOfTypeLabel() {
        typeLabel.textAlignment = .center
        typeLabel.numberOfLines = 1
        typeLabel.font = UIFont(name: Constants.FontName.appleSDGothicNeoRegular, size: 12)
        typeLabel.textColor = .white
    }
    private func setConstraintsOfTypeLabel() {
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(yearLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    private func setTypeLabel(to type: String) {
        typeLabel.text = type
    }
    // MARK: - Favorite Mark Image View
    private func setUpFavoriteMarkImageView() {
        setStyleOfFavoriteMarkImageView()
        setConstraintsOfFavoriteMarkImageView()
        setFavoriteMarkOff()
    }
    private func setStyleOfFavoriteMarkImageView() {
        favoriteMarkImageView.image = Constants.Image.favorite?.withRenderingMode(.alwaysTemplate)
        favoriteMarkImageView.tintColor = .red
    }
    private func setConstraintsOfFavoriteMarkImageView() {
        favoriteMarkImageView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.top).inset(5)
            $0.right.equalTo(posterImageView.snp.right).inset(5)
            $0.width.height.equalTo(posterImageView.snp.width).dividedBy(6)
        }
    }
    // MARK: - Set Contents
    func setContents(poster url: String, title: String, year: String, type: String) {
        setPosterImageView(from: url)
        setTitleLabel(to: title)
        setYearLabel(to: year)
        setTypeLabel(to: type)
    }
    func setFavoriteMarkOn() {
        favoriteMarkImageView.isHidden = false
    }
    func setFavoriteMarkOff() {
        favoriteMarkImageView.isHidden = true
    }
}
