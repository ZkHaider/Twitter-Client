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
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Go ahead and set icon buttons
        prepareIconButtons()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TweetCell {
    
    internal func prepareIconButtons() {
        
        // Create buttons
        let replyButton = IconButton(image: Icon.cm.add, tintColor: Color.grey.base)
        let retweetButton = IconButton(image: Icon.cm.add, tintColor: Color.grey.base)
        let likeButton = IconButton(image: Icon.cm.play, tintColor: Color.red.base)
        let shareButton = IconButton(image: Icon.cm.share, tintColor: Color.grey.base)
        
        // Set pulse colors
        replyButton.pulseColor = Color.grey.base
        retweetButton.pulseColor = Color.grey.base
        likeButton.pulseColor = Color.red.base
        shareButton.pulseColor = Color.grey.base
        
        buttonStackView.insertArrangedSubview(replyButton, at: 0)
        buttonStackView.insertArrangedSubview(retweetButton, at: 1)
        buttonStackView.insertArrangedSubview(likeButton, at: 2)
        buttonStackView.insertArrangedSubview(shareButton, at: 3)
        
        buttonStackView.distribution = UIStackViewDistribution.equalCentering
        buttonStackView.layoutIfNeeded()
    }
    
}
