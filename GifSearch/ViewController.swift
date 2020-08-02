//
//  ViewController.swift
//  GifSearch
//
//  Created by Александр Цветков on 17.07.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let networkService = NetworkService()
        networkService.request(byText: "cats") { (data, error) in
            
        }
        let image = UIImage.gifImageWithURL("https://media0.giphy.com/media/cfuL5gqFDreXxkWQ4o/giphy.gif?cid=f50b613d8m0rlawg42e544y7vz2ycprt54bz7id3z1c7lp4y&rid=giphy.gif")
        let imageView = UIImageView(image: image)
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }


}

