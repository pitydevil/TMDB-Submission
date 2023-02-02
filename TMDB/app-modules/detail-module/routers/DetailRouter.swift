//
//  DetailRouter.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 02/02/23.
//

import Foundation
import UIKit

class DetailRouter : PresenterToRouterDetailProtocol{

    static func createModule() -> DetailViewController {
        let view = mainstoryboard.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        
        let presenter: ViewToPresenterDetailProtocol & InteractorToPresenterDetailProtocol = DetailPresenter()
        let interactor: PresenterToInteractorDetailProtocol = DetailInteractor()
        let router:PresenterToRouterDetailProtocol = DetailRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func pushToDetailScreen(navigationConroller: NavigationController, movieIdObject: Int) {
        let detailModule = DetailRouter.createModule()
        detailModule.movieIdObject.accept(movieIdObject)
        navigationConroller.pushViewController(detailModule, animated: true)
    }
    
    func pushToReviewController(navigationConroller: NavigationController, _ movieReviewList: [Review]) {
        let reviewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "reviewController") as ReviewViewController
        reviewController.movieReviewlist.accept(movieReviewList)
        navigationConroller.present(reviewController, animated: true)
    }
}
