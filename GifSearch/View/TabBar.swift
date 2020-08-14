//
//  TabBar.swift
//  GifSearch
//
//  Created by Александр Цветков on 14.08.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class TabBar: UIView {
    
    private let leftBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "magnifyingGlass")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let rightBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "folderBlack")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftBarButton)
        addSubview(rightBarButton)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(hex: "F7F8FD")
        
        let inset = UIScreen.main.bounds.width / 6
        NSLayoutConstraint.activate([
            leftBarButton.widthAnchor.constraint(equalToConstant: 40),
            rightBarButton.widthAnchor.constraint(equalToConstant: 40),
            leftBarButton.heightAnchor.constraint(equalToConstant: 40),
            rightBarButton.heightAnchor.constraint(equalToConstant: 40),
            
            leftBarButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            rightBarButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset),
            
            leftBarButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightBarButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
