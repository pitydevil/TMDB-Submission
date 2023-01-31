//
//  Shared Objects.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import Foundation
import RxSwift

public let bags = DisposeBag()
public let baseImageURL = "https://image.tmdb.org/t/p/w500/"
public var apiKey: String {
    get {
        guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'TMDB-Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
        fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
    }
    return value
  }
}
