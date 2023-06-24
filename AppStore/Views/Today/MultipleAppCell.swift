//
//  MultipleAppCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 24.06.2023.
//

import UIKit
import SDWebImage

class MultipleAppCell: UICollectionViewCell {
    
    var app: FeedResult! {
        didSet {
            appName.text = app.name
            companyLabel.text = app.artistName
            appIconImage.sd_setImage(with: URL(string: app.artworkUrl100))
        }
    }
    
    let appIconImage: UIImageView = {
        let image = UIImageView()
        image.widthAnchor.constraint(equalToConstant: 64).isActive = true
        image.heightAnchor.constraint(equalToConstant: 64).isActive = true
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.backgroundColor = .purple
        return image
    }()
    
    let appName: UILabel = {
       let label = UILabel()
        label.text = "App Name"
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.text = "Company Name"
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton()
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    let seperatorView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let overallStackView = UIStackView(arrangedSubviews: [
            appIconImage,
            VerticalStackView(arrangedSubviews: [
                appName,
                companyLabel
            ], spacing: 4),
            getButton
        ])
        
        overallStackView.spacing = 16
        overallStackView.alignment = .center
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, leading: appName.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0) ,size: .init(width: 0, height: 0.3))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
