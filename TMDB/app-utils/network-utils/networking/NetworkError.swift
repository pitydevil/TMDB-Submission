//
//  NetworkError.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURLRequest
    case emptyResponse
    case badRequest
    case decoding
    case internalServerError
    case underlying(Error)
}
