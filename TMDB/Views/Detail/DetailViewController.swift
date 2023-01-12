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
    private let detailHomeViewModel  = DetailHomeViewModel()
    private let movieRecommnedationList   : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    private let movieReviewlist      : BehaviorRelay<[Review]> = BehaviorRelay(value: [])
    
    //MARK: VIEW CONTROLLER OBJECT DECLARATION
    private var detailController     : DetailViewController?
    private var reviewController     : ReviewViewController?
    
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
        reviewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "reviewController")     as ReviewViewController
        
        //MARK: Interaction Observer
            //MARK: - Observer for Movie ID Object
            /// Observe movie id value changes, once value's changed, trigger view model on appear function
            /// to fetch from endpoint servers
            movieIdObjectObserver.subscribe(onNext: { [self] (value) in
                SVProgressHUD.show(withStatus: "Fetching Movies Detail")
                Task {
                    await detailHomeViewModel.onAppear(value)
                }
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
            
            //MARK: - Observer for Detail Movie Object
            /// Observe detail movie object value, once there's changes update the necessary UI
            /// from the given components.
            detailHomeViewModel.detailMovieObjectObserver.subscribe(onNext: { [self] (value) in
                SVProgressHUD.dismiss()
                DispatchQueue.main.async { [self] in
                    title = value.title
                    titleLabel.text   = value.title
                    reviewLabel.text  = "Reviews: \(value.voteAverage)"
                    descTextview.text = value.overview

                    //MARK: - Render Star Review Function
                    /// Update stackview Ui to update the amount of review stars
                    /// from the given components.
                    renderStarReview(value.voteAverage)
                }
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
            
            //MARK: - Observer Movie's trailer
            /// Update WkWebView URL  based on  movie's trailer endpoint
            /// from the given components.
            detailHomeViewModel.detailMovieVideosObjectObserver.subscribe(onNext: { [self] (value) in
                DispatchQueue.main.async { [self] in
                    guard let url = URL(string: "https://www.youtube.com/embed/\(value)") else {return}
                    wkWebView.load(URLRequest(url: url))
                }
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
        
            //MARK: - Observer for Review Table View
            /// Update Review Table View based on review Array Count
            /// from the given components.
            detailHomeViewModel.reviewMovieObjectObserver.skip(1).subscribe(onNext: { [self] (value) in
                movieReviewlist.accept(value)
                DispatchQueue.main.async { [self] in
                    switch value.isEmpty {
                        case true:
                            reviewCountLabel.isHidden = false
                            lihatReviewButton.isEnabled   = false
                        case false:
                            reviewCountLabel.isHidden = true
                            lihatReviewButton.isEnabled   = true
                    }
                }
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
        
            //MARK: - Lihat Semua Review Response Function
            /// Segue to review view controller to view all of the movie review.
            lihatReviewButton.rx.tap.bind { [self] in
                reviewController?.movieReviewlist.accept(movieReviewlist.value)
                present(reviewController ?? ReviewViewController(), animated: true)
            }.disposed(by: bags)
        
        //MARK: - Object Observer for UI Logic.
            //MARK: - Observe Movie Recommendation List Value from Endpoint
            /// Returns boolean true or false
            /// from the given components.
            detailHomeViewModel.movieRecommendationObjectArrayObserver.subscribe(onNext: { [self] (value) in
                movieRecommnedationList.accept(value)
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
            
        //MARK: - Observer for Endpoint Error State
            //MARK: - Observer for Handling Error on all endpoints
            /// Inform user if there's any problem with their internet connection via UIAlertController
            /// from the given components.
            detailHomeViewModel.genericHandlingErrorObserver.skip(1).subscribe(onNext: { (value) in
                DispatchQueue.main.async { [self] in
                    SVProgressHUD.dismiss()
                    popupAlert(title: "Telah Terjadi Gangguan di Server!", message: "Silahkan coba beberapa saat lagi.", actionTitles: ["OK"], actionsStyle: [UIAlertAction.Style.cancel] ,actions:[{ [self] (action1) in
                        navigationController!.popToRootViewController(animated: true)
                    },nil])
                }
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
        
            //MARK: - Observer for Handling Movie Video Endpoint
            /// Update user Interface if there's no trailer for the details movie.
            /// from the given components.
            /// - Parameters:
            ///     - notExist: video trailer doesn't exist for current selected movie details.
            detailHomeViewModel.videoHandlingErrorObserver.skip(1).subscribe(onNext: { (value) in
                DispatchQueue.main.async { [self] in
                    switch value {
                        case .notExist:
                            wkWebView.isUserInteractionEnabled = false
                            wkWebView.backgroundColor = .systemGray6
                        default:
                            print("aktif")
                    }
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
                detailController?.movieIdObject.accept(movieRecommnedationList.value[indexPath.row].id)
                navigationController?.pushViewController(detailController ?? DetailViewController(), animated: true)
            }).disposed(by: bags)
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
