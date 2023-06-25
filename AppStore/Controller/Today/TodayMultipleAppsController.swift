//
//  TodayMultipleAppsController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 24.06.2023.
//

import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var feedResults = [FeedResult]()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        //button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .fullScreen {
            setupCloseButton()
        } else {
            collectionView.isScrollEnabled = false
        }
              
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
       
        collectionView.backgroundColor = .white
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
       
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if mode == .fullScreen {
            return feedResults.count
        }
        return min(4, feedResults.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 68
        
        if mode == .fullScreen {
            return .init(width: view.frame.width - 48, height: height)
        }
        //(view.frame.height - 3 * spacing) / 4
        
        return .init(width: collectionView.frame.width, height: (view.frame.height - 3 * spacing) / 4)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
        
        cell.app = self.feedResults[indexPath.item]
        
        return cell
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    fileprivate let mode: Mode
    
    enum Mode {
        case small, fullScreen
    }
    
    init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
