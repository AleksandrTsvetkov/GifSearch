//
//  GifModel.swift
//  GifSearch
//
//  Created by Александр Цветков on 09.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

struct Gif {
    
    let title: String
    let imageData: Data
    var savedDate: Date?
    let width: CGFloat
    
    init(title: String, imageData: Data, width: CGFloat) {
        self.title = title
        self.imageData = imageData
        self.width = width
    }
}
