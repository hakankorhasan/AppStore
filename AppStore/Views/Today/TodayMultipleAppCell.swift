//
//  TodayMultipleAppCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 5.06.2023.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    
    //devamlı kullandığımız bir yapı olduğu için basetodaycell adlı genel bir cell yapısı oluşturduk todayItem değişkeni verdik artık override ederek kullanabiliriz.
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
        }
    }

    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    
    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 32), numberOfLines: 2)
    
    let multipleAppsController = TodayMultipleAppsController()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 16
        multipleAppsController.view.backgroundColor = .red
        
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel, titleLabel,
            multipleAppsController.view
        ], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
