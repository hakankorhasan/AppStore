//
//  MusicController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 29.06.2023.
//

import UIKit
import SDWebImage

class MusicController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let footerCellId = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerCellId)
        
        fetchData()
    }
    
    var results = [Result]()
    
    fileprivate let searchTerm = "taylor"
    
    fileprivate func fetchData() {
        let url = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=20"
        
        Service.shared.fetchGenericJSONData(urlString: url) { (searchResult: SearchResult?, error) in
             
            if let error = error {
                print("error", error)
                return
            }
            
            self.results = searchResult?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellId, for: indexPath)
        
        return footer
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    var isPagination = false
    var isDonePaginating = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
        
        let track = results[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: track.artworkUrl100))
        cell.trackNameLabel.text = track.trackName
        
        if indexPath.item == results.count - 1 && !isPagination {
            print("data fetch")
            let url = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=20"
            
            isPagination = true
            
            Service.shared.fetchGenericJSONData(urlString: url) { (searchResult: SearchResult?, error) in
                 
                if let error = error {
                    print("error", error)
                    return
                }
                
                if searchResult?.results.count == 0 {
                    self.isDonePaginating = true
                }
                
                sleep(2)
                
                self.results += searchResult?.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPagination = false
            }
        }
        return cell
    }
}
