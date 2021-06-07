//
//  TabBarController.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 24.05.2021.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .black
        self.tabBar.isTranslucent = true
        
        let movies = MoviesViewController.create()
        let series = SeriesViewController.create()
        
        self.viewControllers = [movies, series]
    }
}
