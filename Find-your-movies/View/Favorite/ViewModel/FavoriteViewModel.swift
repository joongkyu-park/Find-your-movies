//
//  FavoriteViewModel.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/15.
//

import Foundation

import RxSwift

final class FavoriteViewModel: ViewModel {
    // MARK: - Instances
    private let coreDataManager = CoreDataManager.shared
    private let disposeBag = DisposeBag()
    // MARK: - Properties
    private var favoriteMovies: [MovieItem] = []
    // MARK: - Observable
    let favoriteMoviesSubject = ReplaySubject<[MovieItem]>.create(bufferSize: 1)
    // MARK: - Initializer
    init() {
        fetchFavoriteMovies()
    }
}

// MARK: - Functions
extension FavoriteViewModel {
    // MARK: - Emit
    private func emitFavoriteMovies() {
        Observable.just(favoriteMovies)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.favoriteMoviesSubject.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Core Data
    func fetchFavoriteMovies() {
        do {
        let favoriteMoveEntities = try coreDataManager.fetch()
        favoriteMovies = favoriteMoveEntities.map { MovieItem(title: $0.title, year: $0.year, imdbID: $0.imdbID, type: $0.type, poster: $0.poster) }
            emitFavoriteMovies()
        } catch {
            favoriteMovies = []
        }
    }
    func makeFavoriteOn(at index: Int, completion: (() -> Void)? = nil) { }
    func makeFavoriteOff(at index: Int, completion: (() -> Void)? = nil) {
        guard let movie = movie(at: index) else { return }
        coreDataManager.delete(id: movie.imdbID)
        favoriteMovies.remove(at: index)
        emitFavoriteMovies()
    }
    func updateOrder() {
        coreDataManager.updateOrder(to: favoriteMovies)
    }
    // MARK: - Get Properties
    func movie(at index: Int) -> MovieItem? {
        return favoriteMovies[index]
    }
    func moviesCount() -> Int {
        return favoriteMovies.count
    }
    // MARK: - Set Properties
    func insert(movie: MovieItem, at index: Int) {
        favoriteMovies.insert(movie, at: index)
    }
    func popMovie(at index: Int) -> MovieItem {
        return favoriteMovies.remove(at: index)
    }
}
