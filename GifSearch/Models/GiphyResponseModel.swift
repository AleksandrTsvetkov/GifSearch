//
//  GiphyResponseModel.swift
//  GifSearch
//
//  Created by Александр Цветков on 03.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import Foundation

struct GiphyResponseModel: Decodable {
    let data: Array<DataModel>
    let pagination: PaginationModel
    let meta: MetaModel
}

struct DataModel: Decodable {
    let images: ImagesModel
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
}
