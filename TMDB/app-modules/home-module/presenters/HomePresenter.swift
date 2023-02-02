//
//  HomePresenter.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 31/01/23.
//

import Foundation
import UIKit

class HomePresenter:ViewToPresenterProtocol {
  
    var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    
    func startFetchGenres() async {
        await interactor?.fetchGenres()
    }
    
    func startFetchMovies(_ genreObject: GenreBody, _ resetArgs : Bool) async {
        await interactor?.fetchMovies(genreObject, resetArgs)
    }
    
    func onAppear(_ genreBody: GenreBody) async {
        await interactor?.onAppear(genreBody)
    }
    
    func determineScrollViewPosition(_ scrollView: UIScrollView)  {
        interactor?.determineScrollViewPosition(scrollView)
    }
    
    func showDetailController(navigationController: NavigationController, movieIdObject: Int) {
        router?.pushToDetailScreen(navigationConroller: navigationController, movieIdObject: movieIdObject)
    }
}

extension HomePresenter: InteractorToPresenterProtocol{
   
    func notifeFetchMoviesSuccess(_ moviesArray: Array<Movies>) {
        view?.showMovies(moviesArray)
    }
    
    func noticeFetchGenresSuccess(_ genresArray: [Genres]) {
        view?.showGenres(genresArray)
    }
    
    func noticeScrollViewPosition(_ result: Bool) {
        view?.showScrollViewPosition(result)
    }
    
    func noticeFetchFailed() {
        view?.showError()
    }
}
