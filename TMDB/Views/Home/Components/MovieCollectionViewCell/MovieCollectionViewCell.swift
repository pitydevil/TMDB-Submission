//
//  MovieCollectionViewCell.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {

    //MARK: LAYOUT SUBVIEWS
    @IBOutlet weak var movieImageView : UIImageView!
    
    //MARK: OBJECT DECLARATION
    static let cellID = "MovieCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        movieImageView.setBaseRoundedView()
    }
    
    //MARK: - for Pet Type Value
    /// Returns boolean true or false
    /// from the given components.
    /// - Parameters:
    ///     - allowedCharacter: character subset that's allowed to use on the textfield
    func configureCell(_ movies : Movies) {
        movieImageView.sd_setImage(with: URL(string: "\(baseImageURL)\(movies.posterPath)"), placeholderImage: UIImage(named: "placeholderImage") ?? UIImage(data: Data()))
    }
    
}
