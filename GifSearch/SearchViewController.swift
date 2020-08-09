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
    private var searchBar: UISearchBar!
    private var tableView: UITableView!
    private var timer: Timer?
    private var gifs: Array<Gif> = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        if networkService == nil { networkService = NetworkService() }
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
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
        tableView.register(GifTableViewCell.self, forCellReuseIdentifier: "Cell")
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
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 500),
            activityIndicator.widthAnchor.constraint(equalToConstant: 500)
        ])
    }
}

//MARK: UICollectionViewProtocols
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gifs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GifTableViewCell
        let gif = gifs[indexPath.row]
        let gifImage = UIImage.gifImageWithData(gif.imageData)
        cell.gifImageView.image = gifImage
        cell.nameLabel.text = gif.name
        cell.authorLabel.text = gif.author
        return cell
    }
}

//MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.activityIndicator.startAnimating()
            self?.activityIndicator.isHidden = false
            self?.tableView.isHidden = true
            self?.networkService.request(byText: searchText) { (data, error) in
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
                    self?.gifs = []
                    for gifInfo in response.data {
                        let gif = gifInfo.convert()
                        if let gif = gif { self?.gifs.append(gif) }
                    }
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.isHidden = false
                } catch {
                    print("Failed to decode data in \(#function)\n\(error)")
                }// end catch
            }// end request
        })
    }// end searchBar(_:textDidChange:)
}
