//
//  NorthCarolinaBannerView.swift
//  NotificationBanner
//
//  Created by Dalton Hinterscher on 3/22/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class NorthCarolinaBannerView: UIView {

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        let uncView = teamView(image: #imageLiteral(resourceName: "unc_logo"), record: "27-0", onLeft: true)
        let dukeView = teamView(image: #imageLiteral(resourceName: "duke_logo"), record: "18-9", onLeft: false)
        
        let centerView = UIView()
        addSubview(centerView)
        
        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.systemFont(ofSize: 25.0)
        scoreLabel.text = "98 - 63"
        centerView.addSubview(scoreLabel)
        
        let finalLabel = UILabel()
        finalLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        finalLabel.text = "Final"
        centerView.addSubview(finalLabel)
        
        centerView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(uncView.snp.right).offset(10)
            make.right.equalTo(dukeView.snp.left).offset(-10)
            make.bottom.equalTo(finalLabel)
        }
        
        scoreLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(centerView)
        }
        
        finalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(scoreLabel.snp.bottom)
            make.centerX.equalTo(centerView)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func teamView(image: UIImage, record: String, onLeft: Bool) -> UIView {
        
        let teamView = UIView()
        addSubview(teamView)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        teamView.addSubview(imageView)
        
        let recordLabel = UILabel()
        recordLabel.font = UIFont.systemFont(ofSize: 12.5)
        recordLabel.text = onLeft ? "32-0" : "18-10"
        recordLabel.textAlignment = .center
        teamView.addSubview(recordLabel)
        
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        recordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(2.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        teamView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            if onLeft {
                make.left.equalToSuperview().offset(15)
            } else {
                make.right.equalToSuperview().offset(-15)
            }
            make.bottom.equalTo(recordLabel)
            make.width.equalTo(40)
        }
        
        return teamView
    }
}
