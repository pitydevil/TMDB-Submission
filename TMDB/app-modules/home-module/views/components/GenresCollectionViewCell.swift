//
//  GenresCollectionViewCell.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 30/01/23.
//

import UIKit

class GenresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgCard: UIView!
    @IBOutlet weak var genresLabel: UILabel!
    
    static var cellID = "genresCollectionViewCell"
    
    override func awakeFromNib() {
        bgCard.layer.borderWidth = 0.5
        bgCard.layer.borderColor = UIColor.white.cgColor
        bgCard.layer.cornerRadius = 8
    }
    
    func configureCell(_ genres : Genres)  {
        self.genresLabel.text = genres.name
    }
}
