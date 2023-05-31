//
//  AppDetailsController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 24.05.2023.
//

import UIKit
import SDWebImage

class AppDetailsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let appId: String
    
    //depedcy injection
    init(appId: String) {
        self.appId = appId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var app: Result?
    var reviews: Reviews?
    
    var detailCellId = "detailCellId"
    var previewCellId = "previewCellId"
    var previewRowCellId = "previewRowCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
        navigationItem.largeTitleDisplayMode = .never
        
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        
        collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: previewRowCellId)
        
        fetchData()
        
    }
    
    fileprivate func fetchData() {
        
        let url = "https://itunes.apple.com/lookup?id=\(appId)"
        Service.shared.fetchGenericJSONData(urlString: url) { (result: SearchResult?, err) in
                    
            let app = result?.results.first
            self.app = app
                    
            DispatchQueue.main.async {
                    self.collectionView.reloadData()
            }
        }
            
        let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?1=en&cc=us"
            print(reviewsUrl)
            Service.shared.fetchGenericJSONData(urlString: reviewsUrl) { (reviews: Reviews?, err ) in
                
            if let err = err {
                print("failed to decode reviews")
                    return
            }
                    
            self.reviews = reviews
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
            }
                    
            /*reviews?.feed.entry.forEach({ (entry) in
                print(entry.title, entry.content, entry.author, entry.rating)
            })*/
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 280
        
        if indexPath.item == 0 {
            let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummyCell.app = app
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            height = estimatedSize.height
        } else if indexPath.item == 1 {
            height = 500
        } else {
            height = 280
        }
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! AppDetailCell
            cell.app = app
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
            cell.previewScreenshotsController.app = self.app
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewRowCellId, for: indexPath) as! ReviewRowCell
            cell.reviewsController.reviews = self.reviews
            return cell
        }
        
    }
}
