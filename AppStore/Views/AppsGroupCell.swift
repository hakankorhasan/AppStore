//
//  AppsGroupCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 30.04.2023.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
    }
}

class AppsGroupCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "Apps Section", font: .boldSystemFont(ofSize: 30))
    
    let horizontalView = AppsHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        addSubview(horizontalView.view)
        horizontalView.view.backgroundColor = .blue
        horizontalView.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
