//
//  Movies.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

struct Movies : Decodable{
    let posterPath: String?
    let adult: Bool
    let overview : String
    let genreIDS: [Int]
    let id: Int
    let originalTitle : String
    let title : String
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
}

extension Movies {
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case title
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        posterPath   = try container.decode(String?.self, forKey: .posterPath)
        adult = try container.decode(Bool.self, forKey: .adult)
        overview = try container.decode(String.self, forKey: .overview)
        genreIDS = try container.decode([Int].self, forKey: .genreIDS)
        id       = try container.decode(Int.self, forKey: .id)
        originalTitle       = try container.decode(String.self, forKey: .originalTitle)
        title          =  try container.decode(String.self, forKey: .title)
        popularity   =  try container.decode(Double.self, forKey: .popularity)
        voteCount   =  try container.decode(Int.self, forKey: .voteCount)
        video   =  try container.decode(Bool.self, forKey: .video)
        voteAverage   =  try container.decode(Double.self, forKey: .voteAverage)
    }
}
