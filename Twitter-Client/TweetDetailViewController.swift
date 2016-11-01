//
//  TweetDetailViewController.swift
//  Twitter-Client
//
//  Created by Haider Khan on 11/1/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit
import Material

class TweetDetailViewController: UIViewController {
    
    let cancelButton: IconButton = IconButton(image: Icon.cm.clear, tintColor: Color.grey.lighten1)
    let retweetButton: TwitterButton = TwitterButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45), image: UIImage(named: "retweet_256"))
    let favoriteButton: TwitterButton = TwitterButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40), image: UIImage(named: "favorite-heart-button"))
    let replyButton: TwitterButton = TwitterButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40), image: UIImage(named: "reply"))

    var status: Status?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 30
        
        prepareMainContainer()
        prepareCancelButton()
        prepareStatus()
        prepareButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func retweeted(sender: TwitterButton) {
        if sender.isSelected {
            // deselect
            status?.retweeted = false
            sender.deselect()
            
        } else {
            // select with animation
            status?.retweeted = true
            sender.select()
        }

    }
    
    @objc func favorited(sender: TwitterButton) {
        if sender.isSelected {
            // deselect
            status?.favorited = false
            sender.deselect()
        } else {
            // select with animation
            status?.favorited = true
            sender.select()
        }
    
    }
    
    @objc func replied(sender: TwitterButton) {
        if sender.isSelected {
            // deselect
            status?.replied = false
            sender.deselect()
        } else {
            // select with animation
            status?.replied = true
            sender.select()
        }

    }


}

extension TweetDetailViewController {
    
    internal func prepareMainContainer() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.shadowRadius = 2.0
    }
    
    internal func prepareCancelButton() {
        
        // Prepare pulse
        cancelButton.pulseColor = Color.grey.base
        
        // Layout cancel button
        view.layout(cancelButton)
            .width(30)
            .height(30)
            .topLeft(top: 26, left: 12)
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: UIControlEvents.touchUpInside)
    }
    
    internal func prepareStatus() {
        
        // Update
        self.nameLabel.text = status?.user.name
        self.profileImage.loadImage(url: status?.user.profileImageURL as! URL)
        self.handleLabel.text = "@" + (status?.user.screenName)!
        self.tweetText.text = status?.text
        //        self.mediaImage.loadImage(url: status.mediaImageURL as URL)
        
        // Check flags and set buttons
        if (status?.retweeted)! {
            retweetButton.select()
        } else {
            retweetButton.deselect()
        }
        
        if (status?.favorited)! {
            favoriteButton.select()
        } else {
            favoriteButton.deselect()
        }

    }
    
    internal func prepareButtons() {
        
        retweetButton.imageColorOn = Color.amber.base
        retweetButton.imageColorOff = Color.grey.lighten1
        retweetButton.lineColor = Color.grey.lighten1
        retweetButton.circleColor = Color.amber.base
        retweetButton.tintColor = UIColor.clear
        retweetButton.addTarget(self, action: #selector(retweeted(sender:)), for: .touchUpInside)
        
        favoriteButton.imageColorOn = Color.red.base
        favoriteButton.imageColorOff = Color.grey.lighten1
        favoriteButton.lineColor = Color.grey.lighten1
        favoriteButton.circleColor = Color.red.base
//        favoriteButton.tintColor = UIColor.clear
        favoriteButton.addTarget(self, action: #selector(favorited(sender:)), for: .touchUpInside)
        
        replyButton.imageColorOn = Color.blue.base
        replyButton.imageColorOff = Color.grey.lighten1
        replyButton.lineColor = Color.grey.lighten1
        replyButton.circleColor = Color.blue.base
        replyButton.tintColor = UIColor.clear
        replyButton.addTarget(self, action: #selector(replied(sender:)), for: .touchUpInside)
        
        buttonStackView.insertArrangedSubview(retweetButton, at: 0)
        buttonStackView.insertArrangedSubview(favoriteButton, at: 1)
        buttonStackView.insertArrangedSubview(replyButton, at: 2)
        
        buttonStackView.distribution = UIStackViewDistribution.equalCentering
        buttonStackView.layoutIfNeeded()
    }
    
}
