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

    //MARK: - INIT OBJECT DECLARATION
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
    
    //MARK: - Fetch Now Playing Function
    /// Returns boolean true or false
    /// from the given components.
    func onAppear() async {
        await withTaskGroup(of: Void.self) { [weak self] group in
            guard let self = self else { return }

            /// Returns boolean true or false
            /// from the given components.
            group.addTask {
                await self.fetchMovies(.getNowPlaying)
            }
            
            /// Returns boolean true or false
            /// from the given components.
            group.addTask { [self] in
                await self.fetchMovies(.getUpcoming)
            }
            
            /// Returns boolean true or false
            /// from the given components.
            group.addTask { [self] in
                await self.fetchMovies(.getTopRated)
            }
        }
    }
    
    //MARK: - Fetch Now Playing Function
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    ///     - text: set of character/string that would like  to be checked.
    private func fetchMovies(_ enumState : ApplicationEndpoint) async {
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
                }
            }
        case .failure(_):
            genericHandlingErrorObject.accept(genericHandlingError(rawValue: 500)!)
        }
    }
}
