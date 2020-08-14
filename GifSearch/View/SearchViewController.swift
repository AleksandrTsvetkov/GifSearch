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
    var gifs: Array<Gif> = []
    private var searchBar: UISearchBar!
    var tableView: UITableView!
    private var timer: Timer?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var tableViewManager: TableViewManager!
    private var interactor: SearchInteractor!
    private var presenter: SearchPresenter!
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubModules()
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
        setupTabBar()
    }
    
    //MARK: INITIAL SETUP
    private func setupSubModules() {
        if tableViewManager == nil { tableViewManager = TableViewManager(for: self) }
        if presenter == nil { presenter = SearchPresenter(for: self) }
        if interactor == nil { interactor = SearchInteractor() }
        interactor.presenter = presenter
        interactor.networkService = NetworkService()
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        searchBar.barTintColor = UIColor(hex: "F7F8FD")
    }
    
    private func setupTabBar() {
        let tabBar = TabBar()
        view.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = tableViewManager
        tableView.dataSource = tableViewManager
        tableView.register(GifTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -60),
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

//MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.activityIndicator.startAnimating()
            self?.activityIndicator.isHidden = false
            self?.tableView.isHidden = true
            self?.interactor.makeRequest(ofType: .search(value: searchText), completion: { result in
                switch result {
                case .success(let gifs):
                    self?.gifs = gifs
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.isHidden = false
                case .failure(let error):
                    self?.activityIndicator.stopAnimating()
                    let ac = UIAlertController(title: "Error!", message: "\(error)", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    ac.addAction(ok)
                    self?.present(ac, animated: true)
                }
            })
        })
    }// end searchBar(_:textDidChange:)
}
