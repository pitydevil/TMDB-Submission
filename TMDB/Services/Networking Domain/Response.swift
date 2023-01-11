//
//  Response.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let data: T?
    let error: String?
    let status: Int?
}

struct EmptyData: Decodable {}
