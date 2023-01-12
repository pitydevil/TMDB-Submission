//
//  Enum.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

//MARK: - NETWORKING ENUMERATION DECLARATION
enum HTTPMethod: String {
    case get  = "GET"
    case post = "POST"
    case put  = "PUT"
}

enum genericHandlingError : Int {
    case objectNotFound  = 404
    case methodNotFound  = 405
    case tooManyRequest  = 429
    case success         = 200
    case unexpectedError = 500
}
