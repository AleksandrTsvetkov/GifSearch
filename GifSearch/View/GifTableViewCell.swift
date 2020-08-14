//
//  GifTableViewCell.swift
//  GifSearch
//
//  Created by Александр Цветков on 09.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class GifTableViewCell: UITableViewCell {
    
    //MARK: UI ELEMENTS
    let gifImageView = UIImageView()
    var widthConstraint: NSLayoutConstraint?
    
    //MARK: VIEW LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(gifImageView)
        
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gifImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        gifImageView.image = nil
        widthConstraint?.isActive = false
        widthConstraint = nil
    }
    
    //MARK: Initial setup
    func configure(with gifModel: Gif) {
        //gifImageView.image = UIImage.gif(data: gifModel.imageData)
        gifImageView.image = UIImage(data: gifModel.imageData)
        widthConstraint = gifImageView.widthAnchor.constraint(equalToConstant: gifModel.width)
        widthConstraint?.isActive = true
    }
    
}
