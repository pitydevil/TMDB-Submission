//
//  Response.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

struct EmptyData: Decodable {}

struct Response<T: Decodable>: Decodable {
    let page: Int
    let results: T?
    let totalPages, totalResults: Int
}

struct ResponseReview<T: Decodable>: Decodable {
    let page: Int
    let results: [T]?
    let totalPages, totalResults: Int
}


extension ResponseReview {
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case page, results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalPages   = try container.decode(Int.self, forKey: .totalPages)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
        page         = try container.decode(Int.self, forKey: .page)
        results      = try container.decode([T].self, forKey: .results)
    }
}


extension Response {
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case page, results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalPages   = try container.decode(Int.self, forKey: .totalPages)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
        page         = try container.decode(Int.self, forKey: .page)
        results      = try container.decode(T.self, forKey: .results)
    }
}
