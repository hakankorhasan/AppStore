//
//  AppFullScreenController.swift
//  AppStore
//
//  Created by Hakan Körhasan on 31.05.2023.
//

import UIKit

class AppFullScreenController: UITableViewController {
    
    
    var dismissHandler: (() -> ())?
    
    var todayItem: TodayItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none // satırlardaki çizgileri yok eder normal bir görünüm sağlanır
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false // cellerin tıklanınca gri olan görünümünü kapatır
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let headerCell = AppFullScreenHeaderCell()
            headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 450
        }
        return super.tableView(tableView, heightForRowAt: indexPath) // animasyon ile büyüyen celli küçültürken görüntü kayması oluyor
        // bundan dolayı böyle bir çözüm bulundu
    }
    

    
    
}
