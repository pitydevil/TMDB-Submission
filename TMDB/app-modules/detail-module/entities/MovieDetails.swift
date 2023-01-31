//
//  MovieDetails.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 12/01/23.
//

import Foundation

struct MovieDetails : Decodable{
    let backdropPath: String?
    let budget: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let revenue, runtime: Int
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    init(backdropPath: String = "", budget: Int = 0, homepage: String = "", id: Int = 0, originalLanguage: String = "", originalTitle: String = "", overview: String = "", popularity: Double = 0.0, revenue: Int = 0, runtime: Int = 0, status: String = "", tagline: String = "", title: String = "", video: Bool = false, voteAverage: Double = 0.0, voteCount: Int = 0) {
        self.backdropPath = backdropPath
        self.budget = budget
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.revenue = revenue
        self.runtime = runtime
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

extension MovieDetails  {
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case budget
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        backdropPath   = try container.decode(String?.self, forKey: .backdropPath)
        budget = try container.decode(Int.self, forKey: .budget)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        overview = try container.decode(String.self, forKey: .overview)
        popularity   =  try container.decode(Double.self, forKey: .popularity)
        revenue   =  try container.decode(Int.self, forKey: .revenue)
        runtime   =  try container.decode(Int.self, forKey: .runtime)
        status   =  try container.decode(String.self, forKey: .status)
        tagline   =  try container.decode(String.self, forKey: .tagline)
        title   =  try container.decode(String.self, forKey: .title)
        video   =  try container.decode(Bool.self, forKey: .video)
        voteAverage   =  try container.decode(Double.self, forKey: .voteAverage)
        voteCount   =  try container.decode(Int.self, forKey: .voteCount)
    }
}
