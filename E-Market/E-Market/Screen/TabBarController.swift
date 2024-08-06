//
//  TabBarViewController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initilazeView()
        tabBar.backgroundColor = UIColor.white
    }
    
    private func initilazeView() {
        let homeVC = HomeViewController()
        let cardVC = CartViewController()
        let favoriteVC = FavoritesViewController()
        let profileVC = ProfileController()
        
        let homeNavController = UINavigationController(rootViewController: homeVC)
        let cardNavController = UINavigationController(rootViewController: cardVC)
        let favoriteNavController = UINavigationController(rootViewController: favoriteVC)
        let profileNavController = UINavigationController(rootViewController: profileVC)
        
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))
        cardVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "cart"), selectedImage: UIImage(named: "cart")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))
        favoriteVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "favorite"), selectedImage: UIImage(named: "favorite")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))
        
        viewControllers = [homeNavController, cardNavController, favoriteNavController, profileNavController]
        setupTabBar()
    }
    
    private func setupTabBar() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate,
           let window = delegate.window {
            window.rootViewController = UINavigationController(rootViewController: self)
            window.makeKeyAndVisible()
        }
    }
}
