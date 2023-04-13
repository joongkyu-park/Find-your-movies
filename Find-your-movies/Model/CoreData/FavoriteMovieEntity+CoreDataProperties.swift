//
//  FavoriteMovieEntity+CoreDataProperties.swift
//  
//
//  Created by Apple on 2022/12/14.
//
//

import Foundation
import CoreData

extension FavoriteMovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovieEntity> {
        return NSFetchRequest<FavoriteMovieEntity>(entityName: Constants.Name.favoriteMovieEntity)
    }

    @NSManaged public var id: UUID
    @NSManaged public var imdbID: String
    @NSManaged public var poster: String
    @NSManaged public var title: String
    @NSManaged public var type: String
    @NSManaged public var year: String

}
