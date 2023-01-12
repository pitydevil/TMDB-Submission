//
//  Application Endpoint.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

//MARK: - Application Endpoint Enum State
/// Bind journal list with journalingTableView
enum ApplicationEndpoint {
    case getNowPlaying
    case getTopRated
    case getUpcoming
}

extension ApplicationEndpoint: Endpoint {
    var host: String {
        "api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .getNowPlaying:
            return "/3/movie/now_playing"
        case .getTopRated:
            return "/3/movie/top_rated"
        case .getUpcoming:
            return "/3/movie/upcoming"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getNowPlaying:
            return .get
        case .getTopRated:
            return .get
        case .getUpcoming:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        default:
            return [URLQueryItem(name: "api_key", value: "b5ee67fe1eff1362576110a40fa40c25"), URLQueryItem(name: "language", value: "en-US"), URLQueryItem(name: "page", value: "1")]
        }
    }

    var body: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
}
