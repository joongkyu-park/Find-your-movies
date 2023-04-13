//
//  NetworkManager.swift
//  Find-your-movies
//
//  Created by Apple on 2022/12/14.
//

import Foundation
import Alamofire
import RxSwift

struct NetworkManager {
    func getMovieDataItem(search: String, page: String) -> Observable<MovieDataItem> {
        return Observable.create { emitter in
            let urlString = Constants.Network.baseURL
            + Constants.Network.parameterNameForSearch + search
            + Constants.Network.parameterNameForPage + page
            guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                emitter.onNext(Constants.Model.emptyMovieDataItem)
                return Disposables.create()
            }
            AF.request(encodedURLString,
                       method: .get).responseString { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else { return }
                        let responseDecoded = try JSONDecoder().decode(MovieDataItem.self, from: data)
                        emitter.onNext(responseDecoded)
                    } catch {
                        emitter.onNext(Constants.Model.emptyMovieDataItem)
                    }
                case .failure:
                    emitter.onNext(Constants.Model.emptyMovieDataItem)
                }
            }
            return Disposables.create()
        }
    }
}
