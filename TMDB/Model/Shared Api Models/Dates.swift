//
//  Dates.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

struct Dates: Codable {
    let maximum, minimum: String
}

extension Dates {
    enum CodingKeys: String, CodingKey {
        case maximum = "maximum"
        case minimum = "minimum"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        maximum   = try container.decode(String.self, forKey: .maximum)
        minimum   = try container.decode(String.self, forKey: .minimum)
    }
}
