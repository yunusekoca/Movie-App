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
        
        tabBar.tintColor = .label
        setViewControllers([homeVC], animated: true)
    }
}
