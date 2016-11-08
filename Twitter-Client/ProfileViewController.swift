//
//  ProfileViewController.swift
//  Twitter-Client
//
//  Created by Haider Khan on 11/7/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit
import Material

class ProfileViewController: UIViewController {

    // MARK: - Views
    
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headerViewContainer: UIView!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    // MARK: - Variables

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Prepare things here
        prepareHeaderView()
        prepareProfileImageView()
        prepareCoverImageView()
        prepareUser()
    }

}

extension ProfileViewController {
    
    internal func prepareHeaderView() {
        headerViewContainer.layer.shadowColor = UIColor.black.cgColor
        headerViewContainer.layer.shadowOpacity = 0.7
        headerViewContainer.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        headerViewContainer.layer.shadowRadius = 2.0
        headerViewContainer.clipsToBounds = true
    }
    
    internal func prepareProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowOpacity = 0.7
        profileImageView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        profileImageView.layer.shadowRadius = 2.0
        profileImageView.clipsToBounds = true
    }
    
    internal func prepareCoverImageView() {
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = coverImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerViewContainer.addSubview(blurEffectView)
    }
    
    internal func prepareUser() {
        
        // Go ahead and prepare the user
        coverImageView.loadImage(url: user.backgroundCoverURL as URL)
        profileImageView.loadImage(url: user.profileImageURL as URL)
        
        // Set the labels
        followersLabel.text = String(describing: user.followersCount)
//        followingLabel.text = String(describing: user.followingCount)
        tweetsLabel.text = String(describing: user.tweetCount)
    }
    
}
