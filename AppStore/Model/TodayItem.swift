//
//  TodayItem.swift
//  AppStore
//
//  Created by Hakan Körhasan on 1.06.2023.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    let cellType: CellType
    
    let app: [FeedResult]
    
    enum CellType: String {
       case single, multiple
    }
}
