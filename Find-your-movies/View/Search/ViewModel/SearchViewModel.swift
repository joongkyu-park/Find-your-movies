//
//  SearchViewModel.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/15.
//

import Foundation

import RxSwift
import Alamofire

final class SearchViewModel: ViewModel {
    // MARK: - Instances
    private let networkManager = NetworkManager()
    private let coreDataManager = CoreDataManager.shared
    private let disposeBag = DisposeBag()
    // MARK: - Properties
    private var search: String = ""
    private var movies: [MovieItem] = []
    private var page: Int = 1
    private var totalResults: String = ""
    private var favoriteMovies: [MovieItem] = []
    // MARK: - Observable
    let moviesSubject = ReplaySubject<[MovieItem]>.create(bufferSize: 1)
    // MARK: - Initializer
    init() {
        fetchFavoriteMovies()
    }
}

// MARK: - Functions
extension SearchViewModel {
    // MARK: - Network
    func fetchMovies(from search: String) {
        resetProperties(with: search)
        networkManager.getMovieDataItem(search: search, page: String(page))
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.movies.append(contentsOf: $0.search)
                self.totalResults = $0.totalResults
                self.emitMovies()
            })
            .disposed(by: disposeBag)
    }
    func fetchMovies() {
        if isLastPage() {
            return
        }
        increasePage()
        networkManager.getMovieDataItem(search: search, page: String(page))
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.movies.append(contentsOf: $0.search)
                self.totalResults = $0.totalResults
                self.emitMovies()
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Emit
    private func emitMovies() {
        Observable.just(movies)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.moviesSubject.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Core Data
    func fetchFavoriteMovies() {
        do {
        let favoriteMoveEntities = try coreDataManager.fetch()
        favoriteMovies = favoriteMoveEntities.map { MovieItem(title: $0.title, year: $0.year, imdbID: $0.imdbID, type: $0.type, poster: $0.poster) }
        } catch {
            favoriteMovies = []
        }
    }
    func makeFavoriteOn(at index: Int, completion: (() -> Void)?) {
        guard let movie = movie(at: index) else { return }
        coreDataManager.create(movieItem: movie)
        favoriteMovies.append(movie)
        guard let completion = completion else { return }
        completion()
    }
    func makeFavoriteOff(at index: Int, completion: (() -> Void)?) {
        guard let movie = movie(at: index) else { return }
        coreDataManager.delete(id: movie.imdbID)
        favoriteMovies.enumerated().forEach {
            if $0.element.imdbID == movie.imdbID {
                favoriteMovies.remove(at: $0.offset)
                return
            }
        }
        guard let completion = completion else { return }
        completion()
    }
    // MARK: - Get Properties
    private func isLastPage() -> Bool {
        return totalResults > String(movies.count) ? false : true
    }
    func moviesCount() -> Int {
        return movies.count
    }
    func movie(at index: Int) -> MovieItem? {
        if movies.isEmpty {
            return nil
        }
        return movies[index]
    }
    func isFavoriteMovie(at index: Int) -> Bool {
        guard let movie = movie(at: index) else { return false }
        var isFavorite = false
        favoriteMovies.forEach {
            if $0.imdbID == movie.imdbID {
                isFavorite = true
                return
            }
        }
        return isFavorite
    }
    // MARK: - Set Properties
    private func resetProperties(with search: String) {
        self.search = search
        page = 1
        movies.removeAll()
    }
    private func increasePage() {
        page += 1
    }
}
