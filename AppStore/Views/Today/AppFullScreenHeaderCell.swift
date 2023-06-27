//
//  AppFullScreenHeaderCell.swift
//  AppStore
//
//  Created by Hakan Körhasan on 1.06.2023.
//

import UIKit

class AppFullScreenHeaderCell: UITableViewCell {
    
    let todayCell = TodayCell()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //todayCell'i ekranın üst düzeyine ekliyorsunuz. closeButton ise ana görünüme (self) doğrudan ekleniyor. addSubview kullanırsak bu durumda da akftif olarak gözükecekler fakat dokunmaları algılayamayacaklar
        
        // bu durumda aksiyonların çalışmamasının nedeni işe şöyle dile getirilebilir:
        //closeButton'ın contentView'in bir alt görünümü olduğunda, aksiyonun closeButton'ın üst düzey görünümü olan contentView'e (self.contentView) iletilmesi gerektiğidir. Bunun nedeni, dokunma olayları ve etkileşimlerin genellikle üst düzey görünüme iletildiği ve ardından alt görünümlere yayıldığı iOS görünüm hiyerarşisidir.
        
        //Bu durumda todayCell ve closeButton öğeleri, contentView'in alt görünümleri haline geliyor.
        
        contentView.addSubview(todayCell)
        todayCell.fillSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
