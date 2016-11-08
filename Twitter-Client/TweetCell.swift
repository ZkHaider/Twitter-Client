//
//  TweetCell.swift
//  Twitter-Client
//
//  Created by Haider Khan on 10/29/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit
import Material

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var cellButton: FlatButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    // Our update callback 
    var updateTweet: ((_ updateTweet: Status, _ forIndexPath: IndexPath) -> ())?
    var cellSelected: ((_ status: Status) -> ())?
    var profilePictureTapped: ((_ user: User) -> ())?
    
    var indexPath: IndexPath?
    var status: Status?
    
    let retweetButton: TwitterButton = TwitterButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45), image: UIImage(named: "retweet_256"))
    let favoriteButton: TwitterButton = TwitterButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40), image: UIImage(named: "favorite-heart-button"))
    let replyButton: TwitterButton = TwitterButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40), image: UIImage(named: "reply"))

    func updateWithStatus(status: Status, indexPath: IndexPath, update: @escaping (_ updateTweet: Status, _ forIndexPath: IndexPath) -> ()) {
        
        // Set vars
        self.indexPath = indexPath
        self.status = status
        self.updateTweet = update
        
        // Update
        self.userName.text = status.user.name
        self.userImage.loadImage(url: status.user.profileImageURL as URL)
        self.twitterHandle.text = "@" + status.user.screenName
        self.tweetText.text = status.text
//        self.mediaImage.loadImage(url: status.mediaImageURL as URL)
        
        // Check flags and set buttons
        if status.retweeted {
            retweetButton.select()
        } else {
            retweetButton.deselect()
        }
        
        if status.favorited {
            favoriteButton.select()
        } else {
            favoriteButton.deselect()
        }
    }
    
    func addSelectionCallback(selected: @escaping (_ status: Status) -> ()) {
        self.cellSelected = selected
    }
    
    func addPictureTappedCallback(selected: @escaping (_ user: User) -> ()) {
        self.profilePictureTapped = selected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = 30
        
        // Go ahead and set icon buttons
        prepareButtons()
        prepareUserImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
        // Update our cell
        updateTweet!(status!, indexPath!)
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
        
        // Update our cell
        updateTweet!(status!, indexPath!)
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
        
        // Update our cell
        updateTweet!(status!, indexPath!)
    }
    
    @objc func userImageTapped(sender: UIImageView) {
        profilePictureTapped!((status?.user)!)
    }
    
    @IBAction func cellSelected(_ sender: FlatButton) {
        cellSelected!(status!)
    }

}

extension TweetCell {
    
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
//        favoriteButton.titC
        
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
    
    internal func prepareUserImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userImageTapped(sender:)))
        self.userImage.addGestureRecognizer(tap)
    }

}
