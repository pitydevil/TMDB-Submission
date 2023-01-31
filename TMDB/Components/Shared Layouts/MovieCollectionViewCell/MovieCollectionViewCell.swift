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
    
    //MARK: - Configure Cell
    /// Setup Cell
    /// from the given object
    /// - Parameters:
    ///     - movies: object that's gonna be setup as the base url string for the poster path.
    func configureCell(_ movies : Movies) {
        if movies.posterPath != nil {
            movieImageView.sd_setImage(with: URL(string: "\(baseImageURL)\(movies.posterPath!)"), placeholderImage: UIImage(named: "placeholderImage") ?? UIImage(data: Data()))
        }else {
            movieImageView.image = UIImage(named: "placeholderImage") ?? UIImage(data: Data())
        }
    }
}
