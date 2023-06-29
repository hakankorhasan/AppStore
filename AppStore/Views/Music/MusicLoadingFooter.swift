//
//  MusicLoadingFooter.swift
//  AppStore
//
//  Created by Hakan Körhasan on 29.06.2023.
//

import UIKit

class MusicLoadingFooter: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(text: "Loading more...", font: .boldSystemFont(ofSize: 16))
        
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        
        let stackView =
            VerticalStackView(arrangedSubviews: [
                aiv, label
            ], spacing: 8)
        
        stackView.alignment = .center
        addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 200, height: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
