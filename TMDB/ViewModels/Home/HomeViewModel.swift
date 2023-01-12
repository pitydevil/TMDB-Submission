//
//  HomeViewModel.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel {

    //MARK: - OBJECT DECLARATION
    private let networkService    : NetworkServicing
    private let nowPlayingMoviesArrayObject   = BehaviorRelay<[Movies]>(value: [])
    private let upcomingMoviesArrayObject   = BehaviorRelay<[Movies]>(value: [])
    private let topRatedMoviesArrayObject   = BehaviorRelay<[Movies]>(value: [])
    private var genericHandlingErrorObject = BehaviorRelay<genericHandlingError>(value: .success)
    
    //MARK: - OBJECT OBSERVER DECLARATION
    var nowPlayingMoviesArrayObjectObserver   : Observable<[Movies]> {
        return nowPlayingMoviesArrayObject.asObservable()
    }
    
    var topRatedMoviesArrayObjectObserver   : Observable<[Movies]> {
        return topRatedMoviesArrayObject.asObservable()
    }
    
    var upcomingMoviesArrayObjectObserver   : Observable<[Movies]> {
        return upcomingMoviesArrayObject.asObservable()
    }
    
    var genericHandlingErrorObserver   : Observable<genericHandlingError> {
        return genericHandlingErrorObject.asObservable()
    }

    //MARK: - INIT OBJECT DECLARATION
    init(networkService: NetworkServicing = NetworkService()) {
        self.networkService = networkService
    }
    
    //MARK: - OnAppear Function
    /// Set task group for all async function on appear for detailViewController
    func onAppear() async {
        await withTaskGroup(of: Void.self) { [weak self] group in
            guard let self = self else { return }

            /// Fetch Now Playing Movie from endpoint
            /// from given components.
            group.addTask {
                await self.fetchMovies(.getNowPlaying)
            }
            
            /// Fetch Upcoming Movie from endpoint
            /// from the given components.
            group.addTask { [self] in
                await self.fetchMovies(.getUpcoming)
            }
            
            /// Fetch Top Rated  Movie from endpoint
            /// from the given components.
            group.addTask { [self] in
                await self.fetchMovies(.getTopRated)
            }
        }
    }
    
    //MARK: - Fetch Movies
    /// Fetch Movies
    /// from given components.
    /// - Parameters:
    ///     - enumState: movie type that's gonan be passed onto the fetch movie endpoint
    private func fetchMovies(_ enumState : ApplicationEndpoint<Any>) async {
        let endpoint = enumState
        let result = await networkService.request(to: endpoint, decodeTo: Response<[Movies]>.self)
        switch result {
        case .success(let response):
            if let movies = response.results {
                switch enumState {
                case .getUpcoming:
                    upcomingMoviesArrayObject.accept(movies)
                case .getTopRated:
                    topRatedMoviesArrayObject.accept(movies)
                case .getNowPlaying:
                    nowPlayingMoviesArrayObject.accept(movies)
                default:
                    print("else")
                }
            }
        case .failure(_):
            genericHandlingErrorObject.accept(genericHandlingError(rawValue: 500)!)
        }
    }
}
