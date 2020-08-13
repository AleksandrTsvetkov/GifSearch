//
//  SearchPresenter.swift
//  GifSearch
//
//  Created by Александр Цветков on 13.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class SearchPresenter {
    
    private var viewController: SearchViewController
    
    init(for viewController: SearchViewController) {
        self.viewController = viewController
    }
    
    func getResponse(ofType type: SearchVCModels.Model.Response.ResponseType, completion: @escaping (Result<[Gif], Error>) -> Void) {
        switch type {
        case .success(let result):
            completion(.success(result))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
