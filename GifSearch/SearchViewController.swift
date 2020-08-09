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
    private var tableView: UITableView!
    private var timer: Timer?
    private var gifs: Array<UIImage> = []
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        if networkService == nil { networkService = NetworkService() }
        setupSearchBar()
        setupTableView()
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
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        tableView.isHidden = true
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

//MARK: UICollectionViewProtocols
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if gifs.count >= indexPath.row + 1 {
            cell.backgroundView = UIImageView(image: gifs[indexPath.row])
        }
        return cell
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
                    guard !response.data.isEmpty else { return }
                    self.gifs = []
                    for gifInfo in response.data {
                        let gifUrl = gifInfo.images.original.url
                        guard let gif = UIImage.gifImageWithURL(gifUrl) else { return }
                        self.gifs.append(gif)
                    }
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                } catch {
                    print("Failed to decode data in \(#function)\n\(error)")
                }// end catch
            }// end request
        })
    }// end searchBar(_:textDidChange:)
}
