//
//  Review.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 02/02/23.
//

import Foundation

// MARK: - Result
struct Review: Decodable {
    let author: String
    let authorDetails: AuthorDetails
    let content, createdAt, id, updatedAt: String
    let url: String
    
    init(author: String = "", authorDetails: AuthorDetails = AuthorDetails(name: "", username: "", rating: 0), content: String = "", createdAt: String = "", id: String = "", updatedAt: String = "", url: String = "") {
        self.author = author
        self.authorDetails = authorDetails
        self.content = content
        self.createdAt = createdAt
        self.id = id
        self.updatedAt = updatedAt
        self.url = url
    }
}

extension Review  {
    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author    = try container.decode(String.self, forKey: .author)
        authorDetails   =  try container.decode(AuthorDetails.self, forKey: .authorDetails)
        content   =  try container.decode(String.self, forKey: .content)
        createdAt   =  try container.decode(String.self, forKey: .createdAt)
        id   =  try container.decode(String.self, forKey: .id)
        updatedAt   =  try container.decode(String.self, forKey: .updatedAt)
        url   =  try container.decode(String.self, forKey: .url)
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Decodable {
    let name, username: String
    let rating: Int?
}

extension AuthorDetails {
    enum CodingKeys: String, CodingKey {
        case name, username
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name    = try container.decode(String.self, forKey: .name)
        username   =  try container.decode(String.self, forKey: .username)
        rating   =  try container.decode(Int?.self, forKey: .rating)
    }
}
