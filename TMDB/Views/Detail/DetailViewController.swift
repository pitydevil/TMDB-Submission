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

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.cellId, for: indexPath)
        
        return cell
    }

    //MARK: OBJECT DECLARATION
    
    //MARK: LAYOUT SUBVIEWS
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var starsStackView: UIStackView!
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextview: UITextView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var recommendationCard: CustomViewCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Register Controller
        reviewTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: ReviewTableViewCell.cellId)
        
        //MARK: - Set Navigation Bar Title
        navigationController?.navigationBar.topItem?.title = "Hi There!"
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        //MARK: - Response Collection View DidSelect Delegate Function
        /// Returns boolean true or false
        /// from the given components.
        /// - Parameters:
        ///     - allowedCharacter: character subset that's allowed to use on the textfield
        ///     - text: set of character/string that would like  to be checked.
    
//         let url = URL(string: "https://www.youtube.com/embed/6JnN1DmbqoU")
//         let requestObj = URLRequest(url: url! as URL)
//         wkWebView.load(requestObj)
        
    }
}
