//
//  GifModel.swift
//  GifSearch
//
//  Created by Александр Цветков on 09.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import Foundation

struct Gif {
    
    let author: String
    let name: String
    let imageData: Data
    var savedDate: Date?
    
    init(author: String, name: String, imageData: Data) {
        self.author = author
        self.name = name
        self.imageData = imageData
    }
}
