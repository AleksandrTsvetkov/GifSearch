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
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    private var gifImageViewWidth: CGFloat = 0
    
    let savedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    //MARK: VIEW LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(gifImageView)
        
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, savedDateLabel], axis: .vertical, spacing: 0)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
            
            gifImageView.topAnchor.constraint(equalTo: self.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        savedDateLabel.text = ""
        savedDateLabel.isHidden = true
        gifImageView.image = nil
    }
    
    //MARK: Initial setup
    func configure(with gifModel: Gif) {
        titleLabel.text = gifModel.title
        if let date = gifModel.savedDate {
            savedDateLabel.text = "\(date)"
        }
        gifImageView.image = UIImage.gif(data: gifModel.imageData)
        //gifImageView.image = UIImage(data: gifModel.imageData)
        //gifImageView.widthAnchor.constraint(equalToConstant: gifModel.width).isActive = true
    }
    
}
