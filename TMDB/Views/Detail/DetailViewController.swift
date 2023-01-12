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
    private let detailHomeViewModel = DetailHomeViewModel()
    private let movieRecommnedationList   : BehaviorRelay<[Movies]> = BehaviorRelay(value: [])
    private let movieReviewlist   : BehaviorRelay<[Review]> = BehaviorRelay(value: [])
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
        
        reviewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "reviewController") as ReviewViewController
        
        //MARK: - Observer for Movie ID OBJECT
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        movieIdObjectObserver.subscribe(onNext: { [self] (value) in
            SVProgressHUD.show(withStatus: "Fetching Movies Detail")
            Task {
                await detailHomeViewModel.onAppear(value)
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Observer for Movie ID OBJECT
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        detailHomeViewModel.detailMovieObjectObserver.subscribe(onNext: { [self] (value) in
            SVProgressHUD.dismiss()
            DispatchQueue.main.async { [self] in
                titleLabel.text = value.title
                reviewLabel.text = "Reviews: \(value.voteAverage)"
                descTextview.text = value.overview
                renderStarReview(value.voteAverage)
                title = value.title
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Observer for Movie ID OBJECT
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        detailHomeViewModel.detailMovieVideosObjectObserver.subscribe(onNext: { [self] (value) in
            DispatchQueue.main.async { [self] in
                guard let url = URL(string: "https://www.youtube.com/embed/\(value)") else {return}
                wkWebView.load(URLRequest(url: url))
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Response Collection View DidSelect Delegate Function
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        detailHomeViewModel.movieRecommendationObjectArrayObserver.subscribe(onNext: { [self] (value) in
            movieRecommnedationList.accept(value)
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Response Collection View DidSelect Delegate Function
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
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
        
        //MARK: - Observer for Error State
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        detailHomeViewModel.genericHandlingErrorObserver.skip(1).subscribe(onNext: { (value) in
            DispatchQueue.main.async { [self] in
               present(errorServerAlert(), animated: true) 
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Observer for Handle Video State
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
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
        
        //MARK: - Bind nowPlayingMoviesList with Table View
        /// Bind journal list with journalingTableView
        movieReviewlist.bind(to: reviewTableView.rx.items(cellIdentifier: ReviewTableViewCell.cellId, cellType: ReviewTableViewCell.self)) { row, model, cell in
            cell.configureCell(model)
        }.disposed(by: bags)

        //MARK: - Bind nowPlayingMoviesList with Table View
        /// Bind journal list with journalingTableView
        movieRecommnedationList.bind(to: recommendationCard.collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellID, cellType: MovieCollectionViewCell.self)) { row, model, cell in
            cell.configureCell(model)
        }.disposed(by: bags)
        
        //MARK: - Response Collection View DidSelect Delegate Function
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        recommendationCard.collectionView.rx.itemSelected.subscribe(onNext: { [self] (indexPath) in
            recommendationCard.collectionView.deselectItem(at: indexPath, animated: true)
            detailController?.movieIdObject.accept(movieRecommnedationList.value[indexPath.row].id)
            navigationController?.pushViewController(detailController ?? DetailViewController(), animated: true)
        }).disposed(by: bags)
        
        //MARK: - Response Collection View DidSelect Delegate Function
        lihatReviewButton.rx.tap.bind { [self] in
            reviewController?.movieReviewlist.accept(movieReviewlist.value)
            present(reviewController ?? ReviewViewController(), animated: true)
        }.disposed(by: bags)
    }
    
    //MARK: - Render Star Review
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    ///     - text: set of character/string that would like  to be checked.
    private func renderStarReview(_ voteAverage : Double) {
        starsStackView.arrangedSubviews.forEach {$0.removeFromSuperview()}
        for _ in 0...Int(voteAverage/2.0) {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "star.fill")
            starsStackView.addArrangedSubview(imageView)
        }
    }
}
