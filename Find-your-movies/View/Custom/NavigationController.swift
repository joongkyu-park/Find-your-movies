//
//  NavigationController.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/17.
//

import UIKit

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
    }
}

// MARK: - Set up
extension NavigationController {
    private func setUpNavigationController() {
        setStyleOfNavigationController()
    }
    private func setStyleOfNavigationController() {
        navigationBar.backgroundColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: Constants.FontName.appleSDGothicNeoSemiBold, size: 20)!]
    }
}
