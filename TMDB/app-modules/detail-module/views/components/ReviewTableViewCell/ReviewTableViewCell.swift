//
//  ReviewTableViewCell.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 12/01/23.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    //MARK: LAYOUT SUBSVIEWS
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: OBJECT DECLARATION
    static let cellId = "ReviewTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 16
        self.layer.borderColor  = UIColor.white.cgColor
        self.layer.borderWidth  = 1.0
        self.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Configure Cell
    /// Configure cell based on review object
    /// - Parameters:
    ///     - Review: object that's gonna be parsed onto the user interfaces
    func configureCell(_ review : Review) {
        authorLabel.text     = review.author
        ratingLabel.text     = "Rating: \(review.authorDetails.rating ?? 0)"
        contentTextView.text = review.content
        
        /// Convert String Date into DD-MM-YYYY string format
        dateLabel.text       = changeDateIntoStringDate(Date: changeDateFromString(dateString: review.createdAt))
    }
}
