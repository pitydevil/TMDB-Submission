//
//  Endpoint.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    
    //MARK: Create URLRequest from given URLRequest Components
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
        
        //MARK: Set JSON type as result value of the Endpoint
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let body = body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        return urlRequest
    }
}
