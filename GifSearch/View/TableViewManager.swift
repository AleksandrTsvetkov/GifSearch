//
//  TableViewManager.swift
//  GifSearch
//
//  Created by Александр Цветков on 13.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class TableViewManager: NSObject {
    private var viewController: MainViewController
    
    init(for viewController: MainViewController) {
        self.viewController = viewController
    }
}

//MARK: UITableView protocols
extension TableViewManager: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewController.gifs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GifTableViewCell
        let gif = viewController.gifs[indexPath.row]
        cell.configure(with: gif)
        return cell
    }
}
