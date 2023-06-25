//
//  TodayController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 31.05.2023.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    //fileprivate let cellId = "cellId"
    //fileprivate let multipleApssCellId = "multipleApssCellId"
    
    /*let items = [
        TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single),
        TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1), cellType: .single),
        TodayItem.init(category: "THE DAILY LIST", title: "Test-Drive These CarPlay Apps", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .multiple)
    ]*/
    
    var items = [TodayItem]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = #colorLiteral(red: 0.9490196109, green: 0.9490196109, blue: 0.9490196109, alpha: 1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    fileprivate func fetchData() {
        // app Group
        
        let dispatchGroup = DispatchGroup()
        
        var topPodcasts: AppGroup?
        var topPaidApps: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopFreeApps { appGroup, err in
            print("fetch podcast")
            topPodcasts = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopPaidApps { appGroup, err in
            print("fetch paidApps")
            topPaidApps = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            
            self.activityIndicatorView.stopAnimating()
            
            self.items = [
                TodayItem.init(category: "Daily List", title: topPodcasts?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .multiple, app: topPodcasts?.feed.results ?? []),
                
                TodayItem.init(category: "Daily List", title: topPaidApps?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .multiple, app: topPaidApps?.feed.results ?? []),
                
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, app: []),
                
                TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1), cellType: .single, app: [])
            ]
            
            self.collectionView.reloadData()
        }
        
    }
    
    var appFullScreenController: AppFullScreenController!
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if items[indexPath.row].cellType == .multiple {
            let fullScreen = TodayMultipleAppsController(mode: .fullScreen)
            let navCntrl = BackEnabledNavigationController(rootViewController: fullScreen)
            navCntrl.modalPresentationStyle = .fullScreen
            fullScreen.feedResults = self.items[indexPath.item].app
            present(navCntrl, animated: true)
            return
        }
        
        let appFullScreenController = AppFullScreenController()
        appFullScreenController.todayItem = items[indexPath.row]
        appFullScreenController.dismissHandler = {
            self.handleRemoveView()
        }
        
        let fullscreenView = appFullScreenController.view!
     
        view.addSubview(fullscreenView)
        
        addChild(appFullScreenController)
        
        self.appFullScreenController = appFullScreenController
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
        
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach{($0?.isActive = true)}
        self.view.layoutIfNeeded()
        fullscreenView.layer.cornerRadius = 16
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded()
            
            self.collectionView.isUserInteractionEnabled = false // animasyon başlatılırken false yaptık çünkü bitene kadar kullanıcı dokunmasını algılamasın diye. Bunun sebebi de henüz animasyon bitmeden dokunulunca appFullScreenController silinmeden ekranda kayma sorunu çıkıyor ve istenmeyen bir view daha beliriyor
            
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraints?.constant = 48
            cell.layoutIfNeeded()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    var startingFrame: CGRect?
    
    @objc func handleRemoveView() {
        self.navigationController?.navigationBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.appFullScreenController.tableView.scrollToRow(at: [0,0], at: .top, animated: true)
            
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
           
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraints?.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            //gesture.view?.removeFromSuperview()
            self.appFullScreenController.view.removeFromSuperview()
            self.appFullScreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true // animasyon bitti ve kullanıcı dokunmasını aktifleştirdik
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        
        // cellId = single or multiple bilgisi geliyor bu bilgiye göre de erişilmek istenen cell belirleniyor mesela multiple cell geldi cellId ile birlikte
        //collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        //bu kod ile TodayMultipleAppCell bu yapıyı kullanacağını belirtiyoruz sonrasında da bu şekilde devam ediyor
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        // BaseTodayCell yapısı sayesinde buradaki kod hammallığından da kurtulmuş olduk
        /*
        if let cell = cell as? TodayCell {
            cell.todayItem = items[indexPath.item]
        } else if let cell = cell as? TodayMultipleAppCell {
            cell.todayItem = items[indexPath.item]
        }*/
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleApps)))
        
        return cell
        
    }
    
    @objc fileprivate func handleMultipleApps(gesture: UIGestureRecognizer) {
        
        let collectionView = gesture.view
        
        var superview = collectionView?.superview
      //  let apps = self.items[indexPath.item].app
        while superview != nil {
            
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                
                let apps = self.items[indexPath.item].app
                
                let fullScreen = TodayMultipleAppsController(mode: .fullScreen)
                fullScreen.modalPresentationStyle = .fullScreen
                fullScreen.feedResults = apps
                present(fullScreen, animated: true)
                return
            }
            
            superview = superview?.superview
        }
        
    }
    
    static let cellSize: CGFloat = 500
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}

