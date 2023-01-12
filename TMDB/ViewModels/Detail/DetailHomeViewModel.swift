//
//  DetailHomeViewModel.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 12/01/23.
//

import Foundation
import RxSwift
import RxCocoa

class DetailHomeViewModel {

    //MARK: - INIT OBJECT DECLARATION
    private let networkService    : NetworkServicing
    private let detailMoviesObject   = BehaviorRelay<MovieDetails>(value: MovieDetails())
    private let reviewMovieObject   = BehaviorRelay<[Review]>(value: [])
    private let moviesRecommendationObject   = BehaviorRelay<[Movies]>(value: [])
    private let detailMoviesVideosObject   = BehaviorRelay<String>(value: String())
    private let genericHandlingErrorObject = BehaviorRelay<genericHandlingError>(value: .success)
    private let videoHandlingErrorObject = BehaviorRelay<videoHandlingError>(value: .exist)
    
    //MARK: - OBJECT OBSERVER DECLARATION
    var detailMovieObjectObserver  : Observable<MovieDetails> {
        return detailMoviesObject.asObservable()
    }
    
    var detailMovieVideosObjectObserver  : Observable<String> {
        return detailMoviesVideosObject.asObservable()
    }
    
    var movieRecommendationObjectArrayObserver   : Observable<[Movies]> {
        return moviesRecommendationObject.asObservable()
    }
    
    var reviewMovieObjectObserver   : Observable<[Review]> {
        return reviewMovieObject.asObservable()
    }
    
    var genericHandlingErrorObserver   : Observable<genericHandlingError> {
        return genericHandlingErrorObject.asObservable()
    }
    
    var videoHandlingErrorObserver   : Observable<videoHandlingError> {
        return videoHandlingErrorObject.asObservable()
    }

    //MARK: - INIT OBJECT DECLARATION
    init(networkService: NetworkServicing = NetworkService()) {
        self.networkService = networkService
    }
    
    //MARK: - OnAppear Function
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    func onAppear(_ movieID : Int) async {
        await withTaskGroup(of: Void.self) { [weak self] group in
            guard let self = self else { return }

            /// Returns boolean true or false
            /// from the given components.
            group.addTask {
                await self.fetchDetailMovies(movieID)
            }
            
            /// Returns boolean true or false
            /// from the given components.
            group.addTask { [self] in
                await self.fetchDetailMoviesVideo(movieID)
            }
            
            /// Returns boolean true or false
            /// from the given components.
            group.addTask { [self] in
                await self.fetchMovieRecommendation(movieID)
            }
            
            /// Returns boolean true or false
            /// from the given components.
            group.addTask { [self] in
                await self.fetchMovieReviews(movieID)
            }
        }
    }
    
    //MARK: - Fetch Movie Detail
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    ///     - text: set of character/string that would like  to be checked.
    private func fetchDetailMovies(_ movieID : Int) async {
        let endpoint = ApplicationEndpoint.getDetailMovie(movieID)
        let result = await networkService.request(to: endpoint, decodeTo: MovieDetails.self)
        switch result {
        case .success(let response):
            detailMoviesObject.accept(response)
        case .failure(_):
            genericHandlingErrorObject.accept(genericHandlingError(rawValue: 500)!)
        }
    }
    
    //MARK: - Fetch Movie Videos
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    private func fetchDetailMoviesVideo(_ movieID : Int) async {
        let endpoint = ApplicationEndpoint.getDetailMovieVideos(movieID)
        let result = await networkService.request(to: endpoint, decodeTo: Video.self)
        switch result {
        case .success(let response):
            if !response.results.isEmpty {
                detailMoviesVideosObject.accept(response.results[0].key)
            }else {
                videoHandlingErrorObject.accept(.notExist)
            }
        case .failure(_):
            genericHandlingErrorObject.accept(genericHandlingError(rawValue: 500)!)
        }
    }
    
    //MARK: - Fetch Movie Recommendation
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    private func fetchMovieRecommendation(_ movieID : Int) async {
        let endpoint = ApplicationEndpoint.getMovieRecommendation(movieID)
        let result = await networkService.request(to: endpoint, decodeTo: Response<[Movies]>.self)
        switch result {
        case .success(let response):
            if let movies = response.results {
                moviesRecommendationObject.accept(movies)
            }
        case .failure(_):
            genericHandlingErrorObject.accept(genericHandlingError(rawValue: 500)!)
        }
    }
    
    //MARK: - Fetch Movie Recommendation
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    private func fetchMovieReviews(_ movieID : Int) async {
        let endpoint = ApplicationEndpoint.getDetailMovieReviews(movieID)
        let result = await networkService.request(to: endpoint, decodeTo: ResponseReview<Review>.self)
        switch result {
        case .success(let response):
            if let reviews = response.results {
                reviewMovieObject.accept(reviews)
            }
        case .failure(_):
            genericHandlingErrorObject.accept(genericHandlingError(rawValue: 500)!)
        }
    }
}
