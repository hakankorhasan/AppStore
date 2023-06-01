//
//  AppFullScreenHeaderCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 1.06.2023.
//

import UIKit

class AppFullScreenHeaderCell: UITableViewCell {
    
    let todayCell = TodayCell()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //todayCell'i ekranın üst düzeyine ekliyorsunuz. closeButton ise ana görünüme (self) doğrudan ekleniyor. addSubview kullanırsak bu durumda da akftif olarak gözükecekler fakat dokunmaları algılayamayacaklar
        
        // bu durumda aksiyonların çalışmamasının nedeni işe şöyle dile getirilebilir:
        //closeButton'ın contentView'in bir alt görünümü olduğunda, aksiyonun closeButton'ın üst düzey görünümü olan contentView'e (self.contentView) iletilmesi gerektiğidir. Bunun nedeni, dokunma olayları ve etkileşimlerin genellikle üst düzey görünüme iletildiği ve ardından alt görünümlere yayıldığı iOS görünüm hiyerarşisidir.
        
        //Bu durumda todayCell ve closeButton öğeleri, contentView'in alt görünümleri haline geliyor.
        
        contentView.addSubview(todayCell)
        todayCell.fillSuperview()
        
        contentView.addSubview(closeButton)
        closeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 12), size: .init(width: 80, height: 38))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
