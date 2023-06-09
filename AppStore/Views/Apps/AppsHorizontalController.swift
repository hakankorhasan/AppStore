//
//  AppsHorizontalController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 30.04.2023.
//

import UIKit
import SDWebImage

class AppsHorizontalController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "id12"
    
    var appGroup: AppGroup?
    
    var didSelectHandler: ((FeedResult) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(AppsRowCell.self, forCellWithReuseIdentifier: cellId)
       
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    let topBottomPadding: CGFloat = 12
    let lineSpacing: CGFloat = 10
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = appGroup?.feed.results[indexPath.item] {
            didSelectHandler?(app)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appGroup?.feed.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.height - 2*topBottomPadding - 2*lineSpacing) / 3
        return .init(width: view.frame.width - 48, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsRowCell
        let app = appGroup?.feed.results[indexPath.item]
        cell.appIconImage.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
        cell.appName.text = app?.name
        cell.companyName.text = app?.artistName
        return cell
    }
}
