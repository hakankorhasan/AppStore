//
//  AppsRowCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 30.04.2023.
//

import UIKit

class AppsRowCell: UICollectionViewCell {
    
    let appIconImage: UIImageView = {
       let imv = UIImageView()
        imv.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imv.layer.cornerRadius = 12
        imv.clipsToBounds = true
        imv.backgroundColor = .blue
        return imv
    }()
    
    let appName: UILabel = {
       let label = UILabel()
        label.text = "App Name"
        return label
    }()
    
    let companyName: UILabel = {
       let label = UILabel()
        label.text = "Rockstar"
        return label
    }()
    
    let getButton: UIButton = {
       let button = UIButton()
        button.setTitle("Get", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let overallStackView = UIStackView(arrangedSubviews: [
            appIconImage,
            VerticalStackView(arrangedSubviews: [
                appName,
                companyName
            ], spacing: 4),
            getButton
        ])
        
        overallStackView.spacing = 16
        overallStackView.alignment = .center
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

