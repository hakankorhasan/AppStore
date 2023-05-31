//
//  PreviewRowCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 28.05.2023.
//

import UIKit

class PreviewRowCell: UICollectionViewCell {
    
    let reviewsController = ReviewsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .purple
        
        addSubview(reviewsController.view)
        reviewsController.view.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
