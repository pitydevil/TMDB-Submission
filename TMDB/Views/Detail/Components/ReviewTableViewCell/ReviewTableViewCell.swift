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

    override func layoutSubviews() {

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Response Collection View DidSelect Delegate Function
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    ///     - text: set of character/string that would like  to be checked.
    func configureCell(_ review : Review) {
        self.authorLabel.text = review.author
        self.ratingLabel.text = "Rating: \(review.authorDetails.rating ?? 0)"
        self.contentTextView.text = review.content
        self.dateLabel.text = changeDateIntoStringDate(Date: changeDateFromString(dateString: review.createdAt))
    }
}
