//
//  DetailInteractor.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 02/02/23.
//

import Foundation
import RxCocoa
import RxSwift

class DetailInteractor : PresenterToInteractorDetailProtocol {
    
    //MARK: - OBJECT DECLARATION
    private let networkService    : NetworkServicing
    var presenter: InteractorToPresenterDetailProtocol?
  
    //MARK: - INIT OBJECT DECLARATION
    init(networkService: NetworkServicing = NetworkService()) {
        self.networkService = networkService
    }
    
    //MARK: - OnAppear Function
    /// Set task group for all async function on appear for detailViewController
    /// - Parameters:
    ///     - movieID: id for querying the movie details, recommendation, and movie reviews
    func onAppear(_ movieID : Int) async {
        await withTaskGroup(of: Void.self) { [weak self] group in
            guard let self = self else { return }

            /// Fetch Detail Movie from endpoint
            /// from given components.
            group.addTask {
                await self.fetchDetailMovies(movieID)
            }
            
            /// Fetch Movie Detail Video from endpoint
            /// from given components.
            group.addTask { [self] in
                await self.fetchDetailMoviesVideo(movieID)
            }
            
            /// Fetch Movie Recommendation from endpoint
            /// from given components.
            group.addTask { [self] in
                await self.fetchMovieRecommendation(movieID)
            }
            
            /// Fetch Movie Review from endpoint
            /// from given components.
            group.addTask { [self] in
                await self.fetchMovieReviews(movieID)
            }
        }
    }
    
    //MARK: - Fetch Movie Detail
    /// Fetch Detail Movie from endpoint
    /// from given components.
    /// - Parameters:
    ///     - movieID:  id  for querying the movie details, recommendation, and movie reviews
    func fetchDetailMovies(_ movieID : Int) async {
        let endpoint = ApplicationEndpoint.getDetailMovie(movieID)
        let result = await networkService.request(to: endpoint, decodeTo: MovieDetails.self)
        switch result {
        case .success(let response):
            self.presenter?.noticeDetailMovie(response)
        case .failure(_):
            self.presenter?.noticeFetchFailed()
        }
    }
    
    //MARK: - Fetch Movie Videos
    /// Fetch Movie Video  from endpoint
    /// from given components.
    /// - Parameters:
    ///     - movieID:  id  for querying the movie details, recommendation, and movie reviews
    func fetchDetailMoviesVideo(_ movieID : Int) async {
        let endpoint = ApplicationEndpoint.getDetailMovieVideos(movieID)
        let result = await networkService.request(to: endpoint, decodeTo: Video.self)
        switch result {
        case .success(let response):
            if !response.results.isEmpty {
                self.presenter?.noticeDetailMoviesVideo(response.results[0].key)
            }else {
                self.presenter?.noticeDetailMovieFailed()
            }
        case .failure(_):
            self.presenter?.noticeFetchFailed()
        }
    }
    
    //MARK: - Fetch Movie Recommendation
    /// Fetch Movie Recommendation based on MovieID  from endpoint
    /// - Parameters:
    ///     - movieID:  id  for querying the movie details, recommendation, and movie reviews
    func fetchMovieRecommendation(_ movieID : Int) async {
        let endpoint = ApplicationEndpoint.getMovieRecommendation(movieID)
        let result = await networkService.request(to: endpoint, decodeTo: Response<[Movies]>.self)
        switch result {
        case .success(let response):
            if let movies = response.results {
                self.presenter?.noticeMovieRecommendation(movies)
            }
        case .failure(_):
            self.presenter?.noticeFetchFailed()
        }
    }
    
    //MARK: - Fetch Movie Reviews
    /// Fetch Movie Reviews based on MovieID  from endpoint
    /// - Parameters:
    ///     - movieID:  id  for querying the movie details, recommendation, and movie reviews
    func fetchMovieReviews(_ movieID : Int) async {
        let endpoint = ApplicationEndpoint.getDetailMovieReviews(movieID)
        let result = await networkService.request(to: endpoint, decodeTo: ResponseReview<Review>.self)
        switch result {
        case .success(let response):
            if let reviews = response.results {
                self.presenter?.noticeMovieReviews(reviews)
            }
        case .failure(_):
            self.presenter?.noticeFetchFailed()
        }
    }
}
