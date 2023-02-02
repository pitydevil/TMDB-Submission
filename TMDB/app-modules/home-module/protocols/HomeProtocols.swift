//
//  HomeProtocols.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 31/01/23.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: AnyObject{
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func onAppear(_ genreBody : GenreBody) async
    func startFetchMovies(_ genreObject : GenreBody, _ resetArgs : Bool) async
    func determineScrollViewPosition(_ scrollView : UIScrollView)
    func showDetailController(navigationController:NavigationController, movieIdObject : Int)
}

protocol PresenterToViewProtocol: AnyObject{
    func showMovies(_ moviesArray:Array<Movies>)
    func showGenres(_ genre:Array<Genres>)
    func showScrollViewPosition(_ result : Bool)
    func showError()
}

protocol PresenterToRouterProtocol: AnyObject {
    static func createModule() -> HomeViewController
    func pushToDetailScreen(navigationConroller:NavigationController, movieIdObject : Int)
}

protocol PresenterToInteractorProtocol: AnyObject {
    var presenter:InteractorToPresenterProtocol? {get set}
    func fetchGenres() async
    func fetchMovies(_ genreObject : GenreBody,_ resetArgs : Bool) async
    func onAppear(_ genreObject : GenreBody) async
    func determineScrollViewPosition(_ scrollView : UIScrollView)
}

protocol InteractorToPresenterProtocol: AnyObject {
    func notifeFetchMoviesSuccess(_ moviesArray:Array<Movies>)
    func noticeFetchGenresSuccess(_ genresArray: [Genres])
    func noticeScrollViewPosition(_ result : Bool)
    func noticeFetchFailed()
}
