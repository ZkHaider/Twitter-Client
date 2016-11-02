//
//  RootViewController.swift
//  Twitter-Client
//
//  Created by Haider Khan on 10/29/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit
import Material
import KRProgressHUD

struct FabButtonLayout {
    
    struct Fab {
        static let diameter: CGFloat = 56
    }
    
}

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetDelegate {
    
    // Our tableview to be used for the tweets
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var tweetsTableView: UITableView = UITableView()
    
    // Initialize our fab button
    lazy var fab: FabButton = FabButton(image: Icon.cm.pen, tintColor: .white)
    
    // Our bottom constraint to be initialized later
    var fabBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    // Home timeline statuses
    var statuses: [Status]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.grey.lighten5
        
        // Prepare views
        prepareSearchBar()
        prepareTableView()
        preparePullToRefresh()
        prepareFabTweet()
        prepareKeyNotification()
        
        KRProgressHUD.show(message: "Loading Tweets")
        
        loadTweets()
        
        // Add an observer if we make a tweet add it to the top of the tableview
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: TwitterEvents.StatusPosted), object: nil, queue: nil, using: { (notification) in
            let status = notification.object as! Status
            self.statuses?.insert(status, at: 0)
            self.tweetsTableView.reloadData()
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = statuses?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        // Get status
        let status = statuses![indexPath.row]
        
        // Configure cell
        tweetCell.updateWithStatus(status: status, indexPath: indexPath, update: updateTweet)
        tweetCell.addSelectionCallback(selected: cellSelected)
        
        return tweetCell
    }
    
    func cellSelected(status: Status) {
        
        let tweetDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: "tweetDetailViewController") as! TweetDetailViewController
        tweetDetailViewController.status = status
        self.present(tweetDetailViewController, animated: true, completion: nil)
    }
    
    func updateTweet(status: Status, indexPath: IndexPath) {
        statuses?[indexPath.row] = status
        // Reload cell if you want to - not recommended
    }
    
    @objc func userPulledToRefresh() {
        
        loadTweets()
    }
    
    private func loadTweets() {
        
        TwitterClient.instance.homelineWithParams(params: nil, completion: { (statuses, error) in
            
            if KRProgressHUD.isVisible {
                KRProgressHUD.dismiss()
            }
            
            // End refresh after 0.5 seconds - let the user feel refreshed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            
            if error != nil {
                
                let isRateLimited = error?.code == 429
                if isRateLimited {
                    
                    let alertVC = UIAlertController(title: "", message: "You've exceeded the API Rate Limit", preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            alertVC.dismiss(animated: true, completion: nil)
                    })
                    alertVC.addAction(actionOK)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
            
            if statuses != nil {
                self.statuses = statuses
                self.tweetsTableView.reloadData()
            }
        })
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // TODO: Fix animation
//        // Animate the height
//        UIView.animate(withDuration: 0.1, animations: { () -> Void in
//            self.fabBottomConstraint.constant = -keyboardFrame.size.height + 32
//        })

    }
    
    @objc func fabWasTapped() {
        
        // Go ahead and show a tweet compose controller 
        let tweetComposeViewController = mainStoryboard.instantiateViewController(withIdentifier: "tweetViewController") as! TweetComposeViewController
        tweetComposeViewController.delegate = self
//        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        self.present(tweetComposeViewController, animated: true, completion: nil)
    }
    
    func tweetPassed(status: Status) {
        self.statuses?.insert(status, at: 0)
        self.tweetsTableView.reloadData()
    }

}

extension RootViewController {
    
    internal func prepareSearchBar() {
        
        // Access the searchBar.
        guard let searchBar = searchBarController?.searchBar else {
            return
        }
        
        
    }
    
    internal func prepareTableView() {
        
        tweetsTableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.showsVerticalScrollIndicator = false
        
        tweetsTableView.estimatedRowHeight = 215
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        // Register our cells here
        let nib = UINib(nibName: "TweetCell", bundle: nil)
        tweetsTableView.register(nib, forCellReuseIdentifier: "tweetCell")
        
        self.view.addSubview(tweetsTableView)
    }
    
    internal func preparePullToRefresh() {
        
        refreshControl.backgroundColor = UIColor(red:0.20, green:0.64, blue:0.93, alpha:1.00)
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(userPulledToRefresh), for: UIControlEvents.valueChanged)
        self.tweetsTableView.addSubview(refreshControl)
    }
    
    internal func prepareFabTweet() {
        
        fab.backgroundColor = Color.blue.base
        fab.layer.shadowColor = UIColor.black.cgColor
        fab.layer.shadowOpacity = 0.7
        fab.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        fab.layer.shadowRadius = 3.0
        
        fab.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fab)
        
        // Programmatically add constraints if you want
        fabBottomConstraint = NSLayoutConstraint(item: fab, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -16)
        let rightConstraint = NSLayoutConstraint(item: fab, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -16)
        let heightConstraint = NSLayoutConstraint(item: fab, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: FabButtonLayout.Fab.diameter)
        let widthConstraint = NSLayoutConstraint(item: fab, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: FabButtonLayout.Fab.diameter)
        NSLayoutConstraint.activate([fabBottomConstraint, rightConstraint, widthConstraint, heightConstraint])
        
        // Add target
        fab.addTarget(self, action: #selector(fabWasTapped), for: UIControlEvents.touchUpInside)
    }
    
    internal func prepareKeyNotification() {
        // Add an observer to the tableview
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
}

protocol FeedDelegate {
    func onUserAuthorized()
}
