//
//  Video.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 12/01/23.
//

import Foundation

// MARK: - Welcome
struct Video: Decodable {
    let id: Int
    let results: [Resultx]
    
    init(id: Int = 0, results: [Resultx] = []) {
        self.id = id
        self.results = results
    }
}

extension Video {
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case id      = "id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results   = try container.decode([Resultx].self, forKey: .results)
        id   = try container.decode(Int.self, forKey: .id)
    }
}


// MARK: - Result
struct Resultx: Decodable {
    let key: String
}

extension Resultx {
    enum CodingKeys: String, CodingKey {
        case key
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key   = try container.decode(String.self, forKey: .key)
    }
}
