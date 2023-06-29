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
        
       
        viewControllers = [
            createNavController(viewController: MusicController(), title: "Music", image: "music.note.list"),
            createNavController(viewController: TodayController(), title: "Today", image: "text.book.closed.fill"),
            createNavController(viewController: AppsController(), title: "Apps", image: "square.stack.3d.up.fill"),
            createNavController(viewController: AppSearchController(), title: "Search", image: "magnifyingglass")
        ]
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, image: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        viewController.view.backgroundColor = .white
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        navController.tabBarItem.image = UIImage(systemName: image)
        return navController
    }
}
