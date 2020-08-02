//
//  NetworkService.swift
//  GifSearch
//
//  Created by Александр Цветков on 02.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class NetworkService {
    
    //http://api.giphy.com/v1/gifs/search?q=cats&api_key=GsDyNyv6KEAtHHhRua0MsTZl5PcL5yLT
    let apiKey = "GsDyNyv6KEAtHHhRua0MsTZl5PcL5yLT"
    let path = "/v1/gifs/search"
    let host = "api.giphy.com"
    
    func request(byText searchText: String, completion: @escaping (Data?, Error?) -> Void) {
        
        let url = createUrl(from: searchText)
        let urlRequest = URLRequest(url: url)
        
        let task = createDataTask(from: urlRequest, completion: completion)
        task.resume()
        print(url)
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        let session = URLSession.init(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        return task
    }
    
    private func createUrl(from searchText: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem(name: "q", value: searchText), URLQueryItem(name: "api_key", value: apiKey)]
        print(components.url!)
        
        return components.url!
    }
}
