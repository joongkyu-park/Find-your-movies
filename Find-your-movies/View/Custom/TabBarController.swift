//
//  TabBarController.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/13.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarController()
    }
}

// MARK: - Set up
extension TabBarController {
    private func setUpTabBarController() {
        setStyleOfTabBarController()
        setChildrenViewControllers()
    }
    private func setStyleOfTabBarController() {
        tabBar.tintColor = Constants.Color.base
        tabBar.backgroundColor = .white
        if #available(iOS 13, *) {
            let appearance = tabBar.standardAppearance.copy()
            appearance.configureWithTransparentBackground()
            tabBar.standardAppearance = appearance
        } else {
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
        tabBar.layer.setShadow()
    }
    private func setChildrenViewControllers() {
        setViewControllers([createSearchNavigationController(), createFavoriteNavigationController()], animated: false)
    }
    private func createSearchNavigationController() -> NavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = Constants.TabbarTitle.searchViewController
        searchViewController.tabBarItem.image = Constants.Image.search
        return NavigationController(rootViewController: searchViewController)
    }
    private func createFavoriteNavigationController() -> NavigationController {
        let favoriteViewController = FavoriteViewController()
        favoriteViewController.title = Constants.TabbarTitle.favoriteViewController
        favoriteViewController.tabBarItem.image = Constants.Image.favorite
        return NavigationController(rootViewController: favoriteViewController)
    }
}

extension CALayer {
    func setShadow() {
        shadowColor = UIColor.gray.cgColor
        shadowOpacity = 0.3
        shadowOffset = CGSize(width: 0, height: 0)
        shadowRadius = 6.0
    }
}
