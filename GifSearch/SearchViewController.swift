//
//  SearchViewController.swift
//  GifSearch
//
//  Created by Александр Цветков on 17.07.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: PROPERTIES
    private var networkService: NetworkService!
    private var animatedView: UIImageView!
    private var searchBar: UISearchBar!
    private var timer: Timer?
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = NetworkService()
        setupSearchBar()
        setupAnimatedView()
    }
    
    //MARK: INITIAL SETUP
    private func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func setupAnimatedView() {
        animatedView = UIImageView()
        view.addSubview(animatedView)
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animatedView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            animatedView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            animatedView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            animatedView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

//MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.networkService.request(byText: searchText) { (data, error) in
                if let error = error {
                    print("\(error.localizedDescription) in \(#function)")
                    return
                }
                guard let data = data else {
                    print("Missing data in \(#function)")
                    return
                }
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let response = try jsonDecoder.decode(GiphyResponseModel.self, from: data)
                    let gifUrl = response.data[0].images.original.url
                    self.animatedView.image = UIImage.gifImageWithURL(gifUrl)
                } catch {
                    print("Failed to decode data in \(#function)\n\(error)")
                }// end catch
            }// end request
        })
    }// end searchBar(_:textDidChange:)
}
