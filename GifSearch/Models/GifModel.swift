//
//  GifModel.swift
//  GifSearch
//
//  Created by Александр Цветков on 09.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

struct Gif {
    
    let author: String
    let name: String
    let image: UIImage
    var savedTime: Date?
    
    init(author: String, name: String, image: UIImage) {
        self.author = author
        self.name = name
        self.image = image
    }
}
