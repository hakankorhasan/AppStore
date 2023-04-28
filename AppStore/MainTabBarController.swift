//
//  BaseViewController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 28.04.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .white
        redViewController.navigationItem.title = "Today"
        
        let redController = UINavigationController(rootViewController: redViewController)
        redController.tabBarItem.title = "Today"
        redController.tabBarItem.image = UIImage(systemName: "text.book.closed.fill")
        redController.navigationBar.prefersLargeTitles = true
        
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = .white
        blueViewController.navigationItem.title = "Apps"
        
        let blueController = UINavigationController(rootViewController: blueViewController)
        blueController.tabBarItem.title = "Apps"
        blueController.tabBarItem.image = UIImage(systemName: "square.stack.3d.up.fill")
        blueController.navigationBar.prefersLargeTitles = true
        
        let greenViewController = UIViewController()
        greenViewController.view.backgroundColor = .white
        greenViewController.navigationItem.title = "Search"
        
        let greenController = UINavigationController(rootViewController: greenViewController)
        greenController.tabBarItem.title = "Search"
        greenController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        greenController.navigationBar.prefersLargeTitles = true
        
        viewControllers = [
            redController,
            blueController,
            greenController
        ]
    }
}
