//
//  HeaderView.swift
//  Twitter-Client
//
//  Created by Haider Khan on 11/7/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "E0E0E0")
        self.profileImageView.layoutIfNeeded()
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.height / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setProfileImage(url: URL) {
        self.profileImageView.loadImage(url: url)
    }
    
    func setUserName(name: String) {
        self.userNameLabel.text = name
    }

}
