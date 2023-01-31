//
//  Application Endpoint.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation

//MARK: Application Endpoint Enum State
enum ApplicationEndpoint<T> {
    case getGenres
    case getDiscover(T)
    case getDetailMovie(T)
    case getDetailMovieReviews(T)
    case getDetailMovieVideos(T)
    case getMovieRecommendation(T)
}

extension ApplicationEndpoint: Endpoint {
    
    //MARK: URLRequest Base URL Host Component
    var host: String {
        "api.themoviedb.org"
    }
    
    //MARK: URLRequest Path Component
    var path: String {
        switch self {
        case .getDiscover:
            return "/3/discover/movie"
        case .getDetailMovie(let movieID as Int):
            return "/3/movie/\(movieID)"
        case .getDetailMovieVideos(let movieID as Int):
            return "/3/movie/\(movieID)/videos"
        case .getMovieRecommendation(let movieID as Int):
            return "/3/movie/\(movieID)/similar"
        case .getDetailMovieReviews(let movieID as Int):
            return "/3/movie/\(movieID)/reviews"
        case .getGenres:
            return "/3/genre/movie/list"
        default:
            return ""
        }
    }

    //MARK: URLRequest Method Component
    var method: HTTPMethod {
        switch self {
        case .getDiscover:
            return .get
        case .getDetailMovie:
            return .get
        case .getDetailMovieVideos:
            return .get
        case .getDetailMovieReviews:
            return .get
        case .getGenres:
            return .get
        default:
            return .get
        }
    }
    
    //MARK: URLRequest Query Items Component
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getDiscover(let genreBody as GenreBody):
            return [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "page", value: String(genreBody.page)), URLQueryItem(name: "with_genres", value: genreBody.genresName)]
        default:
            return [URLQueryItem(name: "api_key", value: apiKey)]
        }
    }

    //MARK: URLRequest Body Component
    var body: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
}
