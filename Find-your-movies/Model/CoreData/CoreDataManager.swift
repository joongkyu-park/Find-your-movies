//
//  CoreDataManager.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/14.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.Name.persistentContainer)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var context: NSManagedObjectContext = {
        let newbackgroundContext = self.persistentContainer.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()
}

// MARK: - CRUD
extension CoreDataManager {
    func create(movieItem: MovieItem) {
        context.perform {
            let favoriteMovieEntity = FavoriteMovieEntity(context: self.context)
            favoriteMovieEntity.imdbID = movieItem.imdbID
            favoriteMovieEntity.poster = movieItem.poster
            favoriteMovieEntity.title = movieItem.title
            favoriteMovieEntity.type = movieItem.type
            favoriteMovieEntity.year = movieItem.year
            try? self.context.save()
        }
    }
    func delete(id: String) {
        context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Name.favoriteMovieEntity)
            fetchRequest.predicate = NSPredicate(format: Constants.CoreData.fetchQueryWithID, id as CVarArg)
            guard let favoriteMovieEntity = try? self.context.fetch(fetchRequest).first else { return }
            self.context.delete(favoriteMovieEntity)
            try? self.context.save()
        }
    }
    func fetch() throws -> [FavoriteMovieEntity] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Name.favoriteMovieEntity)
        let favoriteMovieEntities = try context.fetch(fetchRequest) as? [FavoriteMovieEntity] ?? []
        return favoriteMovieEntities
    }
    func fetch(id: String) throws -> FavoriteMovieEntity? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Name.favoriteMovieEntity)
        fetchRequest.predicate = NSPredicate(format: Constants.CoreData.fetchQueryWithID, id as CVarArg)
        let favoriteMovieEntity = try context.fetch(fetchRequest).first as? FavoriteMovieEntity
        return favoriteMovieEntity
    }
    func updateOrder(to newOrderMovies: [MovieItem]) {
        context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Name.favoriteMovieEntity)
            guard let favoriteMovieEntities = try? self.context.fetch(fetchRequest) as? [FavoriteMovieEntity] else { return }
            favoriteMovieEntities.forEach {
                self.context.delete($0)
            }
            _ = newOrderMovies.map { self.create(movieItem: $0) }
        }
    }
}
