//
//  FavoriteMoviesCollectionViewDataSources.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/16.
//

import UIKit

import Reusable
import RxCocoa
import RxSwift

final class FavoriteMoviesCollectionViewDataSources: NSObject, UICollectionViewDataSource, RxCollectionViewDataSourceType {
    typealias Element = [MovieItem]
    let viewModel: FavoriteViewModel
    init(viewModel: inout FavoriteViewModel) {
        self.viewModel = viewModel
    }
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[MovieItem]>) {
        if case .next = observedEvent {
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesCount()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as MoviesCollectionViewCell
        guard let movie = viewModel.movie(at: indexPath.row) else { return cell }
        cell.setContents(poster: movie.poster, title: movie.title, year: movie.year, type: movie.type)
        cell.setFavoriteMarkOn()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movie = viewModel.popMovie(at: sourceIndexPath.row)
        viewModel.insert(movie: movie, at: destinationIndexPath.row)
        viewModel.updateOrder()
    }
}
