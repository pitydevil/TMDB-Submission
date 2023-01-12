//
//  ReviewViewController.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 12/01/23.
//

import UIKit
import RxCocoa
import RxSwift

class ReviewViewController: UIViewController {
    
    //MARK: EXTERNAL OBJECT DECLARATION
    let movieReviewlist   : BehaviorRelay<[Review]> = BehaviorRelay(value: [])
    
    //MARK: - OBJECT OBSERVER DECLARATION
    private var movieReviewListObserver   : Observable<[Review]> {
        return movieReviewlist.asObservable()
    }
    
    //MARK: LAYOUT SUBVIEWS
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - Register Table View Cell
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: ReviewTableViewCell.cellId)
        
        //MARK: - Response Collection View DidSelect Delegate Function
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
        movieReviewListObserver.subscribe(onNext: { (value) in
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        },onError: { error in
            self.present(errorAlert(), animated: true)
        }).disposed(by: bags)
       
        //MARK: - Bind nowPlayingMoviesList with Table View
        /// Bind journal list with journalingTableView
        movieReviewlist.bind(to: tableView.rx.items(cellIdentifier: ReviewTableViewCell.cellId, cellType: ReviewTableViewCell.self)) { row, model, cell in
            cell.configureCell(model)
        }.disposed(by: bags)
    }
}
