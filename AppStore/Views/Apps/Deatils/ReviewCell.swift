//
//  ReviewCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 28.05.2023.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "Title Label", font: .boldSystemFont(ofSize: 15))
    
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    
    let bodyLabel = UILabel(text: "Review Body\nReview Body\nReview Body\n", font: .systemFont(ofSize: 15))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.9393396974, green: 0.9393396974, blue: 0.9393396974, alpha: 1)
        layer.cornerRadius = 12
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel, UIView(), authorLabel
            ]),
            starsLabel,
            bodyLabel
        ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
