//
//  AppFullScreenController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 31.05.2023.
//

import UIKit

class AppFullScreenController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dismissHandler: (() -> ())?
    
    var todayItem: TodayItem?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        view.clipsToBounds = true
        setupCloseButton()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none // satırlardaki çizgileri yok eder normal bir görünüm sağlanır
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false // cellerin tıklanınca gri olan görünümünü kapatır
        tableView.contentInsetAdjustmentBehavior = .never // ekranın üst kısmına görüntünün yayılmasını sağlar, yani görüntü ekranın üstünü komple kapatır
        let height = UIApplication.shared.statusBarFrame.height // status bar ın height değerini aldık
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0) // yazılar alt görünüme çok yakında daha güzel dursun diye status bar kadar boşluk verdik
    }
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        return button
    }()
    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let headerCell = AppFullScreenHeaderCell()
            closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.clipsToBounds = true
            return headerCell
        }
        
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        print("tapped")
        button.isHidden = true
        dismissHandler?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return TodayController.cellSize
        }
        return UITableView.automaticDimension // animasyon ile büyüyen celli küçültürken görüntü kayması oluyor
        // bundan dolayı böyle bir çözüm bulundu
    }
    

    
    
}
