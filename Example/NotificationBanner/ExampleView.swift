//
//  NotificationBannerView.swift
//  NotificationBanner
//
//  Created by Dalton Hinterscher on 3/22/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

protocol ExampleViewDelegate : class {
    func numberOfCells(for section: Int) -> Int
    func notificationBannerTitle(for section: Int) -> String
    func blockColor(at indexPath: IndexPath) -> UIColor
    func notificationTitles(at indexPath: IndexPath) -> (String, String?)
    func notificationImage(at indexPath: IndexPath) -> UIImage?
    func basicNotificationCellSelected(at index: Int)
    func basicNotificationCellWithSideViewsSelected(at index: Int)
    func basicCustomNotificationCellSelected(at index: Int)
    func basicGrowingNotificationCellSelected(at index: Int)
    func basicFloatingNotificationCellSelected(at index: Int)
    func basicStatusBarNotificationCellSelected(at index: Int)
}

class ExampleView: UIView {
    
    weak var delegate: ExampleViewDelegate?
    var queuePositionSegmentedControl: UISegmentedControl!
    var bannerPositionSegmentedControl: UISegmentedControl!

    init(delegate: ExampleViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        
        let queuePositionContentView = UIView()
        addSubview(queuePositionContentView)
        
        let queuePositionSegmentLabel = UILabel()
        queuePositionSegmentLabel.font = UIFont.systemFont(ofSize: 12.5)
        queuePositionSegmentLabel.text = "Queue Position:"
        queuePositionContentView.addSubview(queuePositionSegmentLabel)
        
        queuePositionSegmentedControl = UISegmentedControl(items: ["Front", "Back"])
        queuePositionSegmentedControl.selectedSegmentIndex = 1
        queuePositionContentView.addSubview(queuePositionSegmentedControl)
        
        let bannerPositionContentView = UIView()
        addSubview(bannerPositionContentView)
        
        let bannerPositionSegmentLabel = UILabel()
        bannerPositionSegmentLabel.font = UIFont.systemFont(ofSize: 12.5)
        bannerPositionSegmentLabel.text = "Banner Position:"
        bannerPositionContentView.addSubview(bannerPositionSegmentLabel)
        
        bannerPositionSegmentedControl = UISegmentedControl(items: ["Top", "Bottom"])
        bannerPositionSegmentedControl.selectedSegmentIndex = 0
        bannerPositionContentView.addSubview(bannerPositionSegmentedControl)
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 75.0
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        
        queuePositionContentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalTo(queuePositionSegmentedControl)
        }
        
        queuePositionSegmentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        queuePositionSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(queuePositionSegmentLabel.snp.bottom).offset(3.5)
            make.width.equalTo(150)
            make.height.equalTo(25)
            make.centerX.equalToSuperview()
        }
        
        bannerPositionContentView.snp.makeConstraints { (make) in
            make.top.equalTo(queuePositionContentView)
            make.left.equalTo(self.snp.centerX)
            make.width.equalTo(queuePositionContentView)
            make.height.equalTo(queuePositionContentView)
        }
        
        bannerPositionSegmentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        bannerPositionSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(queuePositionSegmentedControl)
            make.width.equalTo(queuePositionSegmentedControl)
            make.height.equalTo(queuePositionSegmentedControl)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(queuePositionContentView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        backgroundColor = tableView.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ExampleView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.numberOfCells(for: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return delegate!.notificationBannerTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "BasicNotificationBannerCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? BasicNotificationBannerCell
        if cell == nil {
            cell = BasicNotificationBannerCell(reuseIdentifier: reuseIdentifier)
        }
        
        return cell!
    }
}

extension ExampleView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let (title, subtitle) = delegate!.notificationTitles(at: indexPath)
        let blockColor = delegate!.blockColor(at: indexPath)
        let image = delegate!.notificationImage(at: indexPath)
        if let bannerCell = cell as? BasicNotificationBannerCell {
            bannerCell.update(blockColor: blockColor, image: image, title: title, subtitle: subtitle)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            delegate?.basicNotificationCellSelected(at: indexPath.row)
        } else if indexPath.section == 1 {
            delegate?.basicNotificationCellWithSideViewsSelected(at: indexPath.row)
        } else if indexPath.section == 2 {
            delegate?.basicCustomNotificationCellSelected(at: indexPath.row)
        } else if indexPath.section == 3 {
            delegate?.basicGrowingNotificationCellSelected(at: indexPath.row)
        } else if indexPath.section == 4 {
            delegate?.basicFloatingNotificationCellSelected(at: indexPath.row)
        } else if indexPath.section == 5 {
            delegate?.basicStatusBarNotificationCellSelected(at: indexPath.row)
        }
    }
}
