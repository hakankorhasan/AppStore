//
//  TodayController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 31.05.2023.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
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
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurEffectView)
        blurEffectView.fillSuperview()
        blurEffectView.alpha = 0
        
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
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, app: []),
                
                TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1), cellType: .single, app: []),
                TodayItem.init(category: "Daily List", title: topPodcasts?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .multiple, app: topPodcasts?.feed.results ?? []),
                
                TodayItem.init(category: "Daily List", title: topPaidApps?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .multiple, app: topPaidApps?.feed.results ?? []),
            ]
            
            self.collectionView.reloadData()
        }
        
    }
    
    var appFullScreenController: AppFullScreenController!
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    fileprivate func showDailyListFullscreen(_ indexPath: IndexPath) {
        let fullScreen = TodayMultipleAppsController(mode: .fullScreen)
        let navCntrl = BackEnabledNavigationController(rootViewController: fullScreen)
        navCntrl.modalPresentationStyle = .fullScreen
        fullScreen.feedResults = self.items[indexPath.item].app
        present(navCntrl, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.row].cellType {
        case .multiple:
            showDailyListFullscreen(indexPath)
        default:
            showSingleAppsFullscreen(indexPath: indexPath)
        }
        
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullScreenController = AppFullScreenController()
        appFullScreenController.todayItem = items[indexPath.row]
        appFullScreenController.dismissHandler = {
            self.handleAppFullScreenDismissal()
        }
        
        appFullScreenController.view.layer.cornerRadius = 16
        self.appFullScreenController = appFullScreenController
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullScreenController.view.addGestureRecognizer(gesture)

    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        let translationY = gesture.translation(in: appFullScreenController.view).y
        
        
        if gesture.state == .changed {
            
            if translationY > 0 {
                var scale = 1 - translationY / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)
                let transfrom: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullScreenController.view.transform = transfrom
            }
            
        } else if gesture.state == .ended {
             
            if translationY > 0  && translationY > 200 {
                handleAppFullScreenDismissal()
            } else {
                self.appFullScreenController.view.transform = .identity
            }
            
        }
        
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
    }
    
    var anchorConstraints: AnchoredConstraints?
    
    fileprivate func setupFullScreenStartingPost(_ indexPath: IndexPath) {
        let fullscreenView = appFullScreenController.view!
     
        view.addSubview(fullscreenView)
        
        addChild(appFullScreenController)
        
        setupStartingCellFrame(indexPath)
                
        guard let startingFrame = self.startingFrame else { return }
        
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        
        self.anchorConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        
        self.view.layoutIfNeeded()
    }
    
    fileprivate func beginAppFulscreenAnimate() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            
            self.blurEffectView.alpha = 1
            
            self.anchorConstraints?.top?.constant = 0
            self.anchorConstraints?.leading?.constant = 0
            self.anchorConstraints?.width?.constant = self.view.frame.width
            self.anchorConstraints?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded()
            
            self.collectionView.isUserInteractionEnabled = false // animasyon başlatılırken false yaptık çünkü bitene kadar kullanıcı dokunmasını algılamasın diye. Bunun sebebi de henüz animasyon bitmeden dokunulunca appFullScreenController silinmeden ekranda kayma sorunu çıkıyor ve istenmeyen bir view daha beliriyor
            
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraints?.constant = 48
            cell.layoutIfNeeded()
        }
        
    }
    
    fileprivate func showSingleAppsFullscreen(indexPath: IndexPath) {
       
        // #1
        setupSingleAppFullscreenController(indexPath)
        
        // #2
        setupFullScreenStartingPost(indexPath)
        
        // #3
        beginAppFulscreenAnimate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    var startingFrame: CGRect?
    
    @objc func handleAppFullScreenDismissal() {
        self.navigationController?.navigationBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.blurEffectView.alpha = 0
            
            self.appFullScreenController.tableView.scrollToRow(at: [0,0], at: .top, animated: true)
            self.appFullScreenController.view.transform = .identity
            
            self.anchorConstraints?.top?.constant = startingFrame.origin.y
            self.anchorConstraints?.leading?.constant = startingFrame.origin.x
            self.anchorConstraints?.width?.constant = startingFrame.width
            self.anchorConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
           
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraints?.constant = 24
            cell.closeButton.alpha = 0
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
                let navCntrl = BackEnabledNavigationController(rootViewController: fullScreen)
                navCntrl.modalPresentationStyle = .fullScreen
                fullScreen.feedResults = self.items[indexPath.item].app
                present(navCntrl, animated: true)
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

