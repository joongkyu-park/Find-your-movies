//
//  ViewModel.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/18.
//

import Foundation

protocol ViewModel {
    func makeFavoriteOn(at index: Int, completion: (() -> Void)?)
    func makeFavoriteOff(at index: Int, completion: (() -> Void)?)
}
