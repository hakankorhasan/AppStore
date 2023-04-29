//
//  SearchResultCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 28.04.2023.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    let appIconImageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .red
        iv.widthAnchor.constraint(equalToConstant: 70).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    let appName: UILabel = {
       let label = UILabel()
        label.text = "App Name"
        return label
    }()
    
    let categoryName: UILabel = {
        let label = UILabel()
        label.text = "Category Name"
        return label
    }()
    
    let ratingsLabel: UILabel = {
        let label = UILabel()
        label.text = "9.2M"
        return label
    }()
    
    let getButton: UIButton = {
       let button = UIButton()
        button.setTitle("Get", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var screenShotImageView1 = self.createScreenShotImageView()
    lazy var screenShotImageView2 = self.createScreenShotImageView()
    lazy var screenShotImageView3 = self.createScreenShotImageView()
    
    func createScreenShotImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
       
        let topStackView = UIStackView(arrangedSubviews: [
            appIconImageView,
            VerticalStackView(arrangedSubviews: [
                appName,
                categoryName,
                ratingsLabel]),
            getButton])
        topStackView.spacing = 12
        topStackView.alignment = .center
        
        
        let screenShotStackView = UIStackView(arrangedSubviews: [
            screenShotImageView1,
            screenShotImageView2,
            screenShotImageView3])
        screenShotStackView.spacing = 12
        screenShotStackView.distribution = .fillEqually
        
        let overallStackView = VerticalStackView(arrangedSubviews: [
            topStackView, screenShotStackView
            ], spacing: 16)
        
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


