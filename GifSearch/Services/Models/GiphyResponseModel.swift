//
//  GiphyResponseModel.swift
//  GifSearch
//
//  Created by Александр Цветков on 03.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

struct GiphyResponseModel: Decodable {
    let data: Array<DataModel>
    let pagination: PaginationModel
    let meta: MetaModel
}

struct DataModel: Decodable {
    let images: ImagesModel
    let title: String
    
    func convert() -> Gif? {
        do {
            guard
                let url = URL(string: images.original.url),
                let originalWidthInt = Int(images.original.width),
                let originalHeightInt = Int(images.original.height)
                else { return nil }
            let data = try Data(contentsOf: url)
            let originalWidth = CGFloat(originalWidthInt)
            let originalHeight = CGFloat(originalHeightInt)
            let aspectRatio = originalWidth / originalHeight
            let newWidth = 150 * aspectRatio
            return Gif(title: title, previewImageData: data, width: newWidth, url: images.original.url)
        } catch {
            print("Error in \(#function)\n\(error)")
        }
        return nil
    }
}

struct PaginationModel: Decodable {
    let totalCount: Int
    let count: Int
    let offset: Int
}

struct MetaModel: Decodable {
    let status: Int
    let msg: String
    let responseId: String
}

struct ImagesModel: Decodable {
    let original: OriginalImageModel
}

struct OriginalImageModel: Decodable {
    let url: String
    let height: String
    let width: String
}
