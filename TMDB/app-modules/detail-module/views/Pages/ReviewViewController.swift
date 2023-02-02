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
        
        //MARK: - Interaction Logic
            //MARK: - Observer for Movie Value
            /// Update Table View based on movieReviewList
            movieReviewListObserver.subscribe(onNext: { (value) in
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                }
            },onError: { error in
                self.present(errorAlert(), animated: true)
            }).disposed(by: bags)
           
            //MARK: - Bind Movie Review List with Review Table View
            /// Bind Table View with Review Table View
            movieReviewlist.bind(to: tableView.rx.items(cellIdentifier: ReviewTableViewCell.cellId, cellType: ReviewTableViewCell.self)) { row, model, cell in
                /// Configure Table View Cell based on movie review
                cell.configureCell(model)
            }.disposed(by: bags)
    }
}
