//
//  AppsController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 30.04.2023.
//

import UIKit

class AppsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "id"
    let headerId = "headerId"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        
        self.collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
    }
        
    var groups = [AppGroup]()
    
    var headerGroups = [HeaderModel]()
    
    
    //sync
    fileprivate func fetchData() {
        
        let dispacthGroup = DispatchGroup()
        
        var group1: AppGroup?
        var group2: AppGroup?
        var group3: AppGroup?
        var group4: AppGroup?
        
        dispacthGroup.enter()
        Service.shared.fetchTopFreeApps { appGroup, error in
            print("top free")
            dispacthGroup.leave()
            group1 = appGroup
        }
        
        
        dispacthGroup.enter()
        Service.shared.fetchTopChannels { appGroup, error in
            print("top channels")
            dispacthGroup.leave()
            group2 = appGroup
        }
        
        dispacthGroup.enter()
        Service.shared.fetchTopPodcasts { appGroup, error in
            print("top podcasts")
            dispacthGroup.leave()
            group3 = appGroup
        }
        
        dispacthGroup.enter()
        Service.shared.fetchTopSubscriberPodcasts { appGroup, error in
            print("top subscriber podcasts")
            dispacthGroup.leave()
            group4 = appGroup
        }
        
        dispacthGroup.enter()
        Service.shared.fetchHeaderData { headerData, error in
            print("header data fetched")
            dispacthGroup.leave()
            self.headerGroups = headerData ?? []
        }
        
        dispacthGroup.notify(queue: .main) {
            print("completed...")
            
            if let group = group1 {
                self.groups.append(group)
            }
            
            if let group = group2 {
                self.groups.append(group)
            }
            
            if let group = group3 {
                self.groups.append(group)
            }
            
            if let group = group4 {
                self.groups.append(group)
            }
            
            self.collectionView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        
        header.appHeaderHorizontalController.headers = self.headerGroups
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        
        let appGroup = groups[indexPath.item]
        
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalView.appGroup = appGroup
        cell.horizontalView.collectionView.reloadData()
        cell.horizontalView.didSelectHandler = { [weak self] feedResult in
            let vc = AppDetailsController()
            vc.appId = feedResult.id
            vc.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
