//
//  AppCompositionalView.swift
//  AppStore
//
//  Created by Hakan Körhasan on 30.06.2023.
//

import SwiftUI
import SDWebImage

class CompositionalController: UICollectionViewController {
    
    init () {
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.90), heightDimension: .absolute(300)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                
                let kind = UICollectionView.elementKindSectionHeader
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)
                ]
                return section
                
            }
    
        }
        
        
        super.init(collectionViewLayout: layout)
    }
    
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(350)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging // horizontal olabilmesi için yapıyoruz
        section.contentInsets.leading = 16
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var socialApps = [HeaderModel]()
    var appGroup: AppGroup?
    var paidApp: AppGroup?
    var freeApps: AppGroup?
    
    private func fetchApps() {
        fetchAppsDispatchGroup()
    }
    
    class CompositionalHeader: UICollectionReusableView {
        
        let label = UILabel(text: "Editors' Choice Games", font: .boldSystemFont(ofSize: 32))
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(label)
            label.fillSuperview()
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    
    enum AppSection {
        case topSocial
        case grossing
        case free
        case topSubscribers
    }
    
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) {
        (collectionView, indexPath, object) -> UICollectionViewCell? in
        
        if let object = object as? HeaderModel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
            cell.app = object
            
            return cell
        } else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppsRowCell
            cell.app = object
            
            cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
            
            return cell
        }
        
        return nil
    }
    
    @objc func handleGet(button: UIView) {
        
        var superview = button.superview
        
        while superview != nil {
            
            if let cell = superview as? UICollectionViewCell {
                
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                
                guard let objectIClickedOnto = diffableDataSource.itemIdentifier(for: indexPath) else { return }
                
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([objectIClickedOnto])
                
                diffableDataSource.apply(snapshot)
                print(objectIClickedOnto)
                
            }
            superview = superview?.superview
        }
    }
    
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.register(AppsRowCell.self, forCellWithReuseIdentifier: "smallCellId")
        
        navigationItem.rightBarButtonItem = .init(title: "Fetch Subscriber", style: .plain, target: self, action: #selector(fetchApp))
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        setupDiffableDatasource()
    }
    
    @objc fileprivate func handleRefresh() {
        
        collectionView.refreshControl?.endRefreshing()
        
        var snapshot = diffableDataSource.snapshot()
        
        snapshot.deleteSections([.topSubscribers])
        
        diffableDataSource.apply(snapshot)
    }
    
    @objc func fetchApp() {
        
        Service.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/podcasts/top-subscriber/50/podcasts.json") { (appGroup, err) in
            
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.insertSections([.topSubscribers], afterSection: .topSocial)
            
            snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topSubscribers)
            
            self.diffableDataSource.apply(snapshot)
            
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        
        if let object = object as? HeaderModel {
            let appDetailController = AppDetailsController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        } else if let object = object as? FeedResult {
            let appDetailController = AppDetailsController(appId: object.id)
            print(object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        }
    }
    
    private func setupDiffableDatasource() {
        
        collectionView.dataSource = diffableDataSource
        
        diffableDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: self.headerId, for: indexPath) as! CompositionalHeader
            
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)
            
            if section == .grossing {
                header.label.text = "Top Paid Apps"
            } else if section == .free{
                header.label.text = "Top Free Apps"
            } else {
                header.label.text = "Top Subscribers"
            }
            
            return header
        })
        
        Service.shared.fetchHeaderData { (socialApps, err) in
            
            Service.shared.fetchTopPaidApps { appGroup, err in
                
                Service.shared.fetchTopFreeApps { freeApps, err in
                    
                    var snapshot = self.diffableDataSource.snapshot()
                    
                    snapshot.appendSections([.topSocial, .grossing, .free])
                    snapshot.appendItems(socialApps ?? [], toSection: .topSocial)
                    
                    let objects = appGroup?.feed.results ?? []
                    snapshot.appendItems(objects, toSection: .grossing)
                    
                    snapshot.appendItems(freeApps?.feed.results ?? [], toSection: .free)
                    
                    self.diffableDataSource.apply(snapshot)
                }
            
            }
            
        }
    }
  
    /*override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let appId = socialApps[indexPath.item].id
            let appDetailController = AppDetailsController(appId: appId)
            navigationController?.pushViewController(appDetailController, animated: true)
        } else if indexPath.section == 1 {
            let appId = self.appGroup?.feed.results[indexPath.item].id ?? ""
            let appDetailController = AppDetailsController(appId: appId)
            navigationController?.pushViewController(appDetailController, animated: true)
        }
    }*/
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
        
         var title: String?
        
         if indexPath.section == 1 {
             title = appGroup?.feed.title
         } else if indexPath.section == 2 {
             title = paidApp?.feed.title
         } else {
             title = freeApps?.feed.title
         }
         header.label.text = title
        
        return header
    }
    
    /*override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return socialApps.count
        }
        return appGroup?.feed.results.count ?? 0
    }*/
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    /*override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
            let socialApps = self.socialApps[indexPath.item]
            cell.titleLabel.text = socialApps.tagline
            cell.companyLabel.text = socialApps.name
            cell.imageView.sd_setImage(with: URL(string: socialApps.imageUrl))
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppsRowCell
            let smallApps = self.appGroup?.feed.results[indexPath.item]
            cell.appIconImage.sd_setImage(with: URL(string: smallApps?.artworkUrl100 ?? ""))
            cell.appName.text = smallApps?.name
            cell.companyName.text = smallApps?.artistName
            return cell
        }
        
    }*/
}

extension CompositionalController {
    func fetchAppsSynchronously() {
        Service.shared.fetchHeaderData { apps, err in
            self.socialApps = apps ?? []
            Service.shared.fetchTopFreeApps { freeApps, err in
                self.appGroup = freeApps
                Service.shared.fetchTopPaidApps { paidApps, err in
                    self.paidApp = paidApps
                    Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, err) in
                        self.freeApps = appGroup
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func fetchAppsDispatchGroup() {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchHeaderData { appGroup, error in
            self.socialApps = appGroup ?? []
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopFreeApps { appGroup, error in
            self.appGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopPaidApps { appGroup, error in
            self.paidApp = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, err) in
            self.freeApps = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
}

struct AppsView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AppsView>) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
    
    
}

struct AppCompositionalView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AppCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}
