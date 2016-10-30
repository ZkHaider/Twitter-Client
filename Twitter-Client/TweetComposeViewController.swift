//
//  TweetViewController.swift
//  Twitter-Client
//
//  Created by Haider Khan on 10/29/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit
import Material

class TweetComposeViewController: UIViewController {
    
    // X cancel button 
    let cancelButton: IconButton = IconButton(image: Icon.cm.clear, tintColor: Color.grey.lighten1)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.white
        
        // Prepare views
        prepareCancelButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TweetComposeViewController {
    
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
    
}
