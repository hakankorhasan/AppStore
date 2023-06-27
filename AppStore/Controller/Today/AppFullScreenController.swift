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
        
        let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: -self.bottomPadding-90) : .identity
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.floatingView.transform = transform
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
        
        setupFloatingControls()
    }
    
    @objc fileprivate func handleTap() {
        
    }
    
    let floatingView = UIView()
    let bottomPadding = UIApplication.shared.statusBarFrame.height
    
    
    fileprivate func setupFloatingControls() {
        
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gestureRecog)
        
        floatingView.layer.cornerRadius = 16
        floatingView.clipsToBounds = true
        
        
        view.addSubview(floatingView)
        floatingView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 18, bottom: -90, right: 18), size: .init(width: 0, height: 80))
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingView.addSubview(blurEffectView)
        blurEffectView.fillSuperview()
        
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = todayItem?.image
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        
        let getButton = UIButton(title: "GET")
        getButton.layer.cornerRadius = 16
        getButton.setTitleColor(.white, for: .normal)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.backgroundColor = .darkGray
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 18)),
                UILabel(text: "Utilizing your time", font: .systemFont(ofSize: 16))
            ], spacing: 5),
            getButton
        ], customSpacing: 16)
        
        floatingView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
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
