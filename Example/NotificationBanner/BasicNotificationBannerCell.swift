//
//  NotificationBannerCell.swift
//  NotificationBanner
//
//  Created by Dalton Hinterscher on 3/22/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class BasicNotificationBannerCell: UITableViewCell {
    
    private var coloredBlockView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!

    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        coloredBlockView = UIImageView()
        coloredBlockView.contentMode = .scaleAspectFit
        contentView.addSubview(coloredBlockView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0)
        contentView.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 14.0)
        subtitleLabel.textColor = .lightGray
        contentView.addSubview(subtitleLabel)
        
        coloredBlockView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(coloredBlockView.snp.height)
        }
        
        subtitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.bottom.equalTo(coloredBlockView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(blockColor: UIColor?, image: UIImage?, title: String, subtitle: String?) {
        
        if let image = image {
            coloredBlockView.image = image
            coloredBlockView.backgroundColor = .clear
        } else if let blockColor = blockColor {
            coloredBlockView.backgroundColor = blockColor
            coloredBlockView.image = nil
        }
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        if let _ = subtitle {
            subtitleLabel.isHidden = false
            titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(coloredBlockView.snp.right).offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalTo(coloredBlockView)
            }
            
        } else {
            subtitleLabel.isHidden = true
            titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(coloredBlockView.snp.right).offset(15)
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalTo(coloredBlockView)
            }
        }
    }

}
