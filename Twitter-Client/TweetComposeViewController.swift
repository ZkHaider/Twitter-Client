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
    
    @IBOutlet weak var tweetTextField: TextField!
    
    let MAX_CHARACTERS_ALLOWED = 140
    
    // X cancel button 
    let cancelButton: IconButton = IconButton(image: Icon.cm.clear, tintColor: Color.grey.lighten1)
    lazy var tweetFab: FabButton = FabButton(image: Icon.cm.check, tintColor: .white)
    // Our bottom constraint to be initialized later
    var tweetFabBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    var delegate: TweetDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.white
        
        // Prepare views
        prepareCancelButton()
        prepareSendButton()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil, using: { (notification) in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.view.frame = CGRect(x: 0, y: 0, width: keyboardFrameEnd.size.width, height: keyboardFrameEnd.origin.y)
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidHide, object: nil, queue: nil, using: { (notification) in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.view.frame = CGRect(x: 0, y: 0, width: keyboardFrameEnd.size.width, height: keyboardFrameEnd.origin.y)
        })
        
        _ = tweetTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendFabTapped() {
        
        // Get the text from the text field and send it off
        let tweetText = tweetTextField.text
        if !(tweetText?.isEmpty)! {
            
            // Compose parameters
            let params: NSDictionary = ["status": tweetText as AnyObject]
            
            // Send off the status update and dismiss
            TwitterClient.instance.tweetWithParameters(params: params, completion: { (status, error) in
             
                if error != nil {
                    print(error?.localizedDescription ?? "Error")
                    return
                }
                
                if let status = status {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: TwitterEvents.StatusPosted), object: status)
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            let status: NSDictionary = [
                "user": User.currentUser?.dictionary as AnyObject,
                "text": tweetText as AnyObject,
                "favorite_count": 0,
                "retweet_count": 0,
                "favorited": 0,
                "retweeted": 0,
                "created_at": formatter.string(from: date as Date) as AnyObject
            ]
            
            let newStatus = Status(dictionary: status)
            self.delegate?.tweetPassed(status: newStatus)
            self.dismiss(animated: true, completion: nil)
        }
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
    
    internal func prepareSendButton() {
        
        tweetFab.backgroundColor = Color.blue.base
        tweetFab.layer.shadowColor = UIColor.black.cgColor
        tweetFab.layer.shadowOpacity = 0.7
        tweetFab.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tweetFab.layer.shadowRadius = 3.0
        
        tweetFab.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tweetFab)
        
        // Programmatically add constraints if you want
        tweetFabBottomConstraint = NSLayoutConstraint(item: tweetFab, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -16)
        let rightConstraint = NSLayoutConstraint(item: tweetFab, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -16)
        let heightConstraint = NSLayoutConstraint(item: tweetFab, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: FabButtonLayout.Fab.diameter)
        let widthConstraint = NSLayoutConstraint(item: tweetFab, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: FabButtonLayout.Fab.diameter)
        NSLayoutConstraint.activate([tweetFabBottomConstraint, rightConstraint, widthConstraint, heightConstraint])
        
        // Add target
        tweetFab.addTarget(self, action: #selector(sendFabTapped), for: UIControlEvents.touchUpInside)
    }
    
}

protocol TweetDelegate {
    func tweetPassed(status: Status)
}
