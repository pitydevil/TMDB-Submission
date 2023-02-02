//
//  DetailViewController.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 12/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit
import SVProgressHUD

class DetailViewController: UIViewController {

    //MARK: OBJECT DECLARATION
    var presentor : ViewToPresenterDetailProtocol?
    
    private let movieRecommnedationList   : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    private let movieReviewlist      : BehaviorRelay<[Review]> = BehaviorRelay(value: [])
    
    //MARK: VIEW CONTROLLER OBJECT DECLARATION
    private var detailController     : DetailViewController?
    
    //MARK: EXTERNAL OBJECT DECLARATION
    let movieIdObject : BehaviorRelay<Int> = BehaviorRelay(value: Int())
    
    //MARK: - EXTERNAL OBJECT OBSERVER DECLARATION
    var movieIdObjectObserver   : Observable<Int> {
        return movieIdObject.asObservable()
    }
    
    //MARK: LAYOUT SUBVIEWS
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var starsStackView: UIStackView!
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextview: UITextView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var lihatReviewButton: UIButton!
    @IBOutlet weak var recommendationCard: CustomViewCollection!
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //MARK: - Instantiate Collection View Label
        recommendationCard.collectionViewLabel.text  = "Recommended Movies"
        
        //MARK: - Register Table View Cell
        reviewTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: ReviewTableViewCell.cellId)
            
        //MARK: - Register Controller
        detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailViewController") as DetailViewController
       
        
        //MARK: Interaction Observer
            //MARK: - Observer for Movie ID Object
            /// Observe movie id value changes, once value's changed, trigger view model on appear function
            /// to fetch from endpoint servers
            movieIdObjectObserver.subscribe(onNext: { [self] (value) in
                SVProgressHUD.show(withStatus: "Fetching Movies Detail")
                Task {
                    await presentor?.onAppear(value)
                }
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)

        //MARK: - TableView Datasource and Delegate Functions
            //MARK: - Bind Movie Review List with Review Table View
            /// Bind Movie Review List with the review table view
            movieReviewlist.bind(to: reviewTableView.rx.items(cellIdentifier: ReviewTableViewCell.cellId, cellType: ReviewTableViewCell.self)) { row, model, cell in
                /// Configure Table View cell based on review object.
                cell.configureCell(model)
            }.disposed(by: bags)

            //MARK: - Bind Movie Recommendation List with Recommendation Card's collection view
            /// Bind Recommendation List with Recommendation Card's collection view
            movieRecommnedationList.bind(to: recommendationCard.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellID, cellType: MovieCollectionViewCell.self)) { row, model, cell in
                /// Configure collection view  cell based on movie recommendation object.
                cell.configureCell(model)
            }.disposed(by: bags)
            
            //MARK: - Collection View Did Select Delegate Function
            /// Response Collection View Did Select Function, and segue to detail view controller based on user movie's id.
            recommendationCard.collectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
                recommendationCard.collectionView.deselectItem(at: indexPath, animated: true)
                presentor?.showDetailController(navigationController: self.navigationController! as! NavigationController, movieIdObject: movieRecommnedationList.value[indexPath.row].id)
            }).disposed(by: bags)
        
            //MARK: - Object Observer for UI Logic.
                //MARK: - Lihat Semua Review Response Function
                /// Segue to review view controller to view all of the movie review.
                lihatReviewButton.rx.tap.bind { [self] in
                    presentor?.showReviewController(self.navigationController! as! NavigationController, movieReviewlist.value)
                }.disposed(by: bags)
    }
    
    //MARK: - Render Star Review
    /// Render Star based on user review
    /// from the given components.
    /// - Parameters:
    ///     - voteAverage: vote average value from users input.
    private func renderStarReview(_ voteAverage : Double) {
        /// Remove All Star ImageView from superview
        starsStackView.arrangedSubviews.forEach {$0.removeFromSuperview()}
        /// Add Star based on user vote
        for _ in 0...Int(voteAverage/2.0) {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "star.fill")
            starsStackView.addArrangedSubview(imageView)
        }
    }
}

extension DetailViewController : PresenterToViewDetailProtocol {
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    /// - Parameters:
    ///     - enumState: movie type that's gonan be passed onto the fetch movie endpoint
    func showMovieReviews(_ reviewMovieobject: [Review]) {
        movieReviewlist.accept(reviewMovieobject)
        DispatchQueue.main.async { [self] in
            switch reviewMovieobject.isEmpty {
                case true:
                    reviewCountLabel.isHidden = false
                    lihatReviewButton.isEnabled   = false
                case false:
                    reviewCountLabel.isHidden = true
                    lihatReviewButton.isEnabled   = true
            }
        }
    }
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    func showDetailMovieFailed() {
        wkWebView.isUserInteractionEnabled = false
        wkWebView.backgroundColor = .systemGray6
    }
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    /// - Parameters:
    ///     - enumState: movie type that's gonan be passed onto the fetch movie endpoint
    func showDetailMovie(_ detailMoviesObject: MovieDetails) {
        SVProgressHUD.dismiss()
        DispatchQueue.main.async { [self] in
            title = detailMoviesObject.title
            titleLabel.text   = detailMoviesObject.title
            reviewLabel.text  = "Reviews: \(detailMoviesObject.voteAverage)"
            descTextview.text = detailMoviesObject.overview

            //MARK: - Render Star Review Function
            /// Update stackview Ui to update the amount of review stars
            /// from the given components.
            renderStarReview(detailMoviesObject.voteAverage)
        }
    }
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    /// - Parameters:
    ///     - enumState: movie type that's gonan be passed onto the fetch movie endpoint
    func showDetailMoviesVideo(_ detailMoviesVideosobject: String) {
        DispatchQueue.main.async { [self] in
            guard let url = URL(string: "https://www.youtube.com/embed/\(detailMoviesVideosobject)") else {return}
            wkWebView.load(URLRequest(url: url))
        }
    }
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    /// - Parameters:
    ///     - enumState: movie type that's gonan be passed onto the fetch movie endpoint
    func showMovieRecommendation(_ movies: [Movies]) {
        movieRecommnedationList.accept(movies)
    }
    
    //MARK: - Observer for Upcoming Movie List
    /// Update upcomingMovieList on value changes
    func showError() {
        DispatchQueue.main.async { [self] in
            popupAlert(title: "Telah Terjadi Gangguan di Server!", message: "Silahkan coba beberapa saat lagi.", actionTitles: ["OK"], actionsStyle: [UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                navigationController!.popToRootViewController(animated: true)
            }])
        }
    }
}
