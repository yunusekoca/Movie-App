//
//  TabBarViewController.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 29.08.2022.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.title = "Ana Sayfa"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.title = "Ara"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        tabBar.tintColor = .label
        setViewControllers([homeVC, searchVC], animated: true)
    }
}
