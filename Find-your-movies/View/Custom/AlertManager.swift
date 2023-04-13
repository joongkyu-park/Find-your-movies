//
//  AlertManager.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/18.
//

import UIKit

final class AlertManager {
    func alertForFavoriteOn(viewModel: ViewModel, title: String, index: Int, completion: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "< \(title) >\n" + Constants.Text.titleForFavoriteOnAlert, message: nil, preferredStyle: .alert)
        let favoriteAction = UIAlertAction(title: Constants.Text.titleForFavoriteOnAction, style: UIAlertAction.Style.default, handler: { _ in
            viewModel.makeFavoriteOn(at: index) {
                completion()
            }
        })
        let cancelAction = UIAlertAction(title: Constants.Text.titleForCancelAction, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(favoriteAction)
        alert.addAction(cancelAction)
        return alert
    }
    func alertForFavoriteOff(viewModel: ViewModel, title: String, index: Int, completion: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "< \(title) >\n" + Constants.Text.titleForFavoriteOffAlert, message: nil, preferredStyle: .alert)
        let favoriteOffAction = UIAlertAction(title: Constants.Text.titleForFavoriteOffAction, style: UIAlertAction.Style.default, handler: { _ in
            viewModel.makeFavoriteOff(at: index) {
                completion()
            }
        })
        let cancelAction = UIAlertAction(title: Constants.Text.titleForCancelAction, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(favoriteOffAction)
        alert.addAction(cancelAction)
        return alert
    }
}
