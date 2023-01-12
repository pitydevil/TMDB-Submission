//
//  Endpoint.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

extension Endpoint {
    var method: HTTPMethod { .get }
    var header: [String: String]? { nil }
    var body: [String: Any]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let body = body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        return urlRequest
    }
}
