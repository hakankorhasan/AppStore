//
//  SearchResultCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 28.04.2023.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    var appResult: Result! {
        didSet {
            appName.text = appResult.trackName
            categoryName.text = appResult.primaryGenreName
            ratingsLabel.text = "\(appResult.averageUserRating ?? 0)"
            
            let url = URL(string: appResult.artworkUrl100)
            appIconImageView.sd_setImage(with: url)
            
            screenShotImageView1.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
            
            if appResult.screenshotUrls.count > 1 {
                screenShotImageView2.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
            }
            
            if appResult.screenshotUrls.count > 2 {
                screenShotImageView3.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
            }
            
        }
    }
    
    let appIconImageView: UIImageView = {
       let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 70).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
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
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.contentMode = .scaleAspectFill
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


