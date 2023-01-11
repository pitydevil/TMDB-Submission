//
//  NavigationController.swift
//  TMDB
//
//  Created by Mikhael Adiputra on 11/01/23.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.shadowColor = .clear
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor.black

            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
