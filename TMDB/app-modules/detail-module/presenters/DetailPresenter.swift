//
//  DetailPresenter.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 02/02/23.
//

import Foundation

class DetailPresenter : ViewToPresenterDetailProtocol{
    var view: PresenterToViewDetailProtocol?
    
    var interactor: PresenterToInteractorDetailProtocol?
    
    var router: PresenterToRouterDetailProtocol?
    
    func onAppear(_ movieID: Int) async {
        await interactor?.onAppear(movieID)
    }
    
    func showDetailController(navigationController: NavigationController, movieIdObject: Int) {
        router?.pushToDetailScreen(navigationConroller: navigationController, movieIdObject: movieIdObject)
    }
    
    func showReviewController(_ navigationController: NavigationController, _ movieReviewList: [Review]) {
        router?.pushToReviewController(navigationConroller: navigationController, movieReviewList)
    }
}

extension DetailPresenter : InteractorToPresenterDetailProtocol {
    func noticeDetailMovieFailed() {
        view?.showDetailMovieFailed()
    }
    
    func noticeDetailMovie(_ detailMoviesObject: MovieDetails) {
        view?.showDetailMovie(detailMoviesObject)
    }
    
    func noticeDetailMoviesVideo(_ detailMoviesVideosobject: String) {
        view?.showDetailMoviesVideo(detailMoviesVideosobject)
    }
    
    func noticeMovieRecommendation(_ movies: [Movies]) {
        view?.showMovieRecommendation(movies)
    }
    
    func noticeMovieReviews(_ reviewMovieobject: [Review]) {
        view?.showMovieReviews(reviewMovieobject)
    }
    
    func noticeFetchFailed() {
        view?.showError()
    }
}
