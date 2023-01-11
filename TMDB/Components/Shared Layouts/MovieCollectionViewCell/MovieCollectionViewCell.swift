//
//  MovieCollectionViewCell.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.setBaseRoundedView()
    }
    
    func setupCell() {
        
    }

}
