//
//  Genres.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 30/01/23.
//

import Foundation

// MARK: - Welcome
struct Genre: Codable {
    let genres: [Genres]
}

// MARK: - Genre
struct Genres: Codable {
    let id: Int
    let name: String
}
