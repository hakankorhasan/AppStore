//
//  AppSearchController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 28.04.2023.
//

import UIKit


class AppSearchController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .black
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
