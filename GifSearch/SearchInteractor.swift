//
//  SearchInteractor.swift
//  GifSearch
//
//  Created by Александр Цветков on 13.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class SearchInteractor {
    
    var presenter: SearchPresenter!
    var networkService: NetworkService!
    
    func makeRequest(ofType type: SearchVCModels.Model.Request.RequestType, completion: @escaping (Result<[Gif], Error>) -> Void) {
        switch type {
        case .search(let searchText):
            self.networkService.request(byText: searchText) { (data, error) in
                if let error = error {
                    print("Error in \(#function)\n\(error)")
                    return
                }
                guard let data = data else {
                    print("Missing data in \(#function)")
                    return
                }
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let response = try jsonDecoder.decode(GiphyResponseModel.self, from: data)
                    guard !response.data.isEmpty else { return }
                    
                    var gifArray: Array<Gif> = []
                    for gifInfo in response.data {
                        let gif = gifInfo.convert()
                        if let gif = gif { gifArray.append(gif) }
                    }
                    self.presenter.getResponse(ofType: .success(result: gifArray), completion: completion)
                    
                } catch {
                    print("Failed to decode data in \(#function)\n\(error)")
                    self.presenter.getResponse(ofType: .failure(error: error), completion: completion)
                }// end catch
            }
        }
    }
}

