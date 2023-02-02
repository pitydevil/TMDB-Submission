//
//  DetailProtocols.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 02/02/23.
//

import Foundation

protocol ViewToPresenterDetailProtocol: AnyObject{
    var view: PresenterToViewDetailProtocol? {get set}
    var interactor: PresenterToInteractorDetailProtocol? {get set}
    var router: PresenterToRouterDetailProtocol? {get set}
    func onAppear(_ movieID : Int) async
    func showDetailController(navigationController:NavigationController, movieIdObject : Int)
    func showReviewController(_ navigationController:NavigationController, _ movieReviewList : [Review])
}

protocol PresenterToViewDetailProtocol: AnyObject{
    func showDetailMovie(_ detailMoviesObject : MovieDetails)
    func showDetailMoviesVideo(_ detailMoviesVideosobject : String)
    func showMovieRecommendation(_ movies : [Movies])
    func showMovieReviews(_ reviewMovieobject : [Review])
    func showDetailMovieFailed()
    func showError()
}

protocol PresenterToRouterDetailProtocol: AnyObject {
    static func createModule() -> DetailViewController
    func pushToDetailScreen(navigationConroller:NavigationController, movieIdObject : Int)
    func pushToReviewController(navigationConroller:NavigationController, _ movieReviewList : [Review])
}

protocol PresenterToInteractorDetailProtocol: AnyObject {
    var presenter:InteractorToPresenterDetailProtocol? {get set}
    func onAppear(_ movieID : Int) async
}

protocol InteractorToPresenterDetailProtocol: AnyObject {
    func noticeDetailMovie(_ detailMoviesObject : MovieDetails)
    func noticeDetailMoviesVideo(_ detailMoviesVideosobject : String)
    func noticeMovieRecommendation(_ movies : [Movies])
    func noticeMovieReviews(_ reviewMovieobject : [Review])
    func noticeDetailMovieFailed()
    func noticeFetchFailed()
}
