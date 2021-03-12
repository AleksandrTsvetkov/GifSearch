//
//  Presenter.swift
//  GifSearch
//
//  Created by Александр Цветков on 13.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class Presenter {
    
    private var viewController: MainViewController
    
    init(for viewController: MainViewController) {
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
