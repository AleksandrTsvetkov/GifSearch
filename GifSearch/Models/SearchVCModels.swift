//
//  SearchVCModels.swift
//  GifSearch
//
//  Created by Александр Цветков on 13.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

enum SearchVCModels {
    
    enum Model {
        struct Request {
            enum RequestType {
                case search(value: String)
            } // RequestType
        } // Request
        
        struct Response {
            enum ResponseType {
                case success(result: Array<Gif>)
                case failure(error: Error)
            } // ResponseType
        } // Response
        
    } // Model
} // SearchVCModels
