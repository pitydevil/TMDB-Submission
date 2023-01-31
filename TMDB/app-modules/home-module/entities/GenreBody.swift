//
//  GenreBody.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 30/01/23.
//

import Foundation

struct GenreBody {
    let page : Int
    let genresName : String
    init(page: Int = 1, genresName: String = "") {
        self.page = page
        self.genresName = genresName
    }
}
