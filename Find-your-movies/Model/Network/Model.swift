//
//  Model.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/14.
//

import Foundation

struct MovieDataItem: Codable {
    let search: [MovieItem]
    let totalResults: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

struct MovieItem: Codable {
    let title, year, imdbID, type, poster: String

    enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
