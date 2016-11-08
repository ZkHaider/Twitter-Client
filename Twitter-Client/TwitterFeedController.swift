//
//  ViewController.swift
//  Twitter-Client
//
//  Created by Haider Khan on 10/29/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit
import Material
import KFSwiftImageLoader

class TwitterFeedController: SearchBarController, UITableViewDataSource, UITableViewDelegate {
    
    var menuButton: IconButton!
    var moreButton: IconButton!
    
    let menuWidth = UIScreen.main.bounds.width * (2 / 3)
    var menuView: UIView!
    var headerView: HeaderView!
    
    // We need a temp value holder for the constraint as well
    var originalLeadingConstant: CGFloat = 0.0
    var leadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    // Flag used to keep track of whether side menu is open or not 
    var sideMenuOpened: Bool = false
    var isSideMenuAnimating: Bool = false // Figure out how to use later
    
    // Our tableview used for holding menu items 
    var menuTableView: UITableView!
    
    let menuItems: [String] = ["Home", "Profile"]
    
    open override func prepare() {
        super.prepare()
        
        // Prepare out menuview 
        let yPos = searchBar.bounds.height + UIApplication.shared.statusBarFrame.height
        menuView = UIView(frame: CGRect(x: 0, y: yPos, width: menuWidth, height: self.rootViewController.view.bounds.height))
        
        // Prepare views
        prepareMenuButton()
        prepareMoreButton()
        prepareStatusBar()
        prepareSearchBar()
        preparePanGestureRecognizer()
        prepareMenuView()
        prepareProfileHeaderView()
        prepareMenuTableView()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        // Set the background color to clear
        self.view.backgroundColor = UIColor.clear
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Go ahead and load in the user image 
//        if (User.currentUser?.profileImageURL) != nil {
//            self.headerView.setProfileImage(url: User.currentUser?.profileImageURL as! URL)
//        }
//        
//        if (User.currentUser?.name) != nil {
//            self.headerView.setUserName(name: (User.currentUser?.name)!)
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }

    @objc func dismissKeyboard() {
        searchBar.textField.text = ""
        searchBar.endEditing(true)
    }
    
    @objc func morePressed() {
        let alertController = UIAlertController(title: "Logout?", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
            if action.isEnabled {
                alertController.dismiss(animated: true, completion: nil)
            }
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            if action.isEnabled {
                alertController.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        
        // Get our values
        let translation = panGesture.translation(in: self.rootViewController.view)
        let velocity = panGesture.velocity(in: self.rootViewController.view)
        // Figure out what to do with the velocity ?
        
        // We need a threshold point where we fully animate our the menuview if it reaches this 
        // value or greater 
        let threshold = menuWidth / 2
        
        // Gesture statement
        if panGesture.state == UIGestureRecognizerState.began {
            
            // We save the original constant here 
            self.originalLeadingConstant = self.leadingConstraint.constant
            
        } else if panGesture.state == UIGestureRecognizerState.changed {
            
            // Create our new constant 
            let newConstant = self.originalLeadingConstant + translation.x

            // If the translation is between 0 and menuwidth then go ahead and do an animation
            if (newConstant >= -menuWidth && newConstant <= 0) {
                
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0.0,
                    options: UIViewAnimationOptions.curveEaseIn, animations: {
                        
                        // Now go ahead and set the leading constraint constant 
                        self.leadingConstraint.constant = self.originalLeadingConstant + translation.x
                        
                    },
                    completion: { (_) in
                        self.sideMenuOpened = true
                    })
            }
            
        } else if panGesture.state == UIGestureRecognizerState.ended {
            
            // If the threshold point is reached then fully animate out the menu view
            // TODO: catch negative translation x here
            if (translation.x <= menuWidth && translation.x >= threshold) {
                
                UIView.animate(
                    withDuration: 0.6,
                    delay: 0.0,
                    options: UIViewAnimationOptions.curveEaseIn, animations: {
                        
                        // Now go ahead and set the leading constraint constant
                        self.leadingConstraint.constant = 0
                        
                    },
                    completion: { (_) in
                        self.sideMenuOpened = true
                    })
                
            } else if (translation.x < threshold) {
                
                UIView.animate(
                    withDuration: 0.6,
                    delay: 0.0,
                    options: UIViewAnimationOptions.curveEaseIn, animations: {
                        
                        // Now go ahead and set the leading constraint constant
                        self.leadingConstraint.constant = -self.menuWidth
                        
                    },
                    completion: { (_) in
                        self.sideMenuOpened = false
                    })
                
            }
            
        }
    }
    
    @objc func toggleSideMenu() {
        
        // Firstly handle the case where the side menu is not opened 
        if !sideMenuOpened {
            
            self.sideMenuOpened = true
            
            // Then animate out the side menu 
            UIView.animate(
                withDuration: 1.0,
                delay: 0.0,
                options: UIViewAnimationOptions.curveEaseIn,
                animations: {
                    
                    // Now go ahead and set the leading constraint constant
                    self.leadingConstraint.constant = 0
                    
                },
                completion: { (_) in
                    self.sideMenuOpened = true
                })
            
        } else {
            
            self.sideMenuOpened = false
            
            UIView.animate(
                withDuration: 1.0,
                delay: 0.0,
                options: UIViewAnimationOptions.curveEaseIn, animations: {
                    
                    // Now go ahead and set the leading constraint constant
                    self.leadingConstraint.constant = -self.menuWidth
                    
                },
                completion: { (_) in
                    
                })
        }
    }
    
    // MARK: - TableView Methods 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            // User hit home - transition to the home view controller
            let homeViewController = RootViewController()
            self.transition(to: homeViewController)
            view.bringSubview(toFront: menuView)
            
            break
        case 1:
            
            // User hit profile - transition to the profile view controller
            let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
            profileViewController.user = User.currentUser
            self.transition(to: profileViewController)
            view.bringSubview(toFront: menuView)
            
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCellTableViewCell
        
        // Get our menu item 
        let menuItem = menuItems[indexPath.row]
        
        // Go ahead and set our menu item label
        cell.itemLabel.text = menuItem
        
        return cell
    }
    
}

extension TwitterFeedController {
    
    internal func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.tintColor = UIColor.white
        menuButton.pulseColor = .white
        
        menuButton.addTarget(self, action: #selector(toggleSideMenu), for: .touchUpInside)
    }

    internal func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreVertical)
        moreButton.tintColor = UIColor.white
        moreButton.pulseColor = .white
        
        moreButton.addTarget(self, action: #selector(morePressed), for: .touchUpInside)
    }

    internal func prepareStatusBar() {
        
        statusBarStyle = .lightContent
        
        // Access the statusBar
        self.statusBarController?.statusBar.backgroundColor = Color.blue.base
    }

    internal func prepareSearchBar() {
        
        searchBar.leftViews = [menuButton]
        searchBar.rightViews = [moreButton]
        searchBar.backgroundColor = Color.blue.base
        searchBar.placeholderColor = UIColor.white
        searchBar.textColor = UIColor.white
        searchBar.tintColor = UIColor.white
        searchBar.clearButton.tintColor = UIColor.white
        searchBar.clearButton.pulseColor = .white
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 0.7
        searchBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchBar.layer.shadowRadius = 2.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        searchBar.clearButton.addGestureRecognizer(tap)
    }

    internal func preparePanGestureRecognizer() {
        
        // Initialize a pan gesture recognizer and add it to the current root view controller's main view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    internal func prepareMenuView() {
        
        // Turn off our autoresizingmaskintoconstraints 
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add a shadow 
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.7
        menuView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        menuView.layer.shadowRadius = 2.0
        
        // TODO: change the background color to something better later
        menuView.backgroundColor = Color.grey.lighten5
        
        // Add as a subview
        view.addSubview(menuView)
        
        let topSpace = searchBar.bounds.height + UIApplication.shared.statusBarFrame.height
                
        let topConstraint = NSLayoutConstraint(item: menuView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: topSpace)
        let bottomConstraint = NSLayoutConstraint(item: menuView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: menuView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: menuWidth)
        leadingConstraint = NSLayoutConstraint(item: menuView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: -menuWidth)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, widthConstraint, leadingConstraint])
    }
    
    internal func prepareProfileHeaderView() {
        
        // Go ahead and prepare the profile header 
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: menuWidth, height: 160))
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Go ahead and add it to the menuview 
        menuView.addSubview(headerView)
        
        // Define our constraints 
        let leadingConstraint = NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: menuView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: menuView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: menuView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 160.0)
        
        // Go ahead and add the constraints 
        NSLayoutConstraint.activate([leadingConstraint, topConstraint, trailingConstraint, heightConstraint])
        
    }
    
    internal func prepareMenuTableView() {
        
        let height = menuView.bounds.height - headerView.bounds.height
        menuTableView = UITableView(frame: CGRect(x: 0, y: headerView.bounds.height, width: menuWidth, height: height))
        
        // Register our cells here
        let nib = UINib(nibName: "MenuCellTableViewCell", bundle: nil)
        menuTableView.register(nib, forCellReuseIdentifier: "menuCell")
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        // Add the menu tableview to the menu view 
        menuView.addSubview(menuTableView)
        
        // Setup our constraints 
        let topConstraint = NSLayoutConstraint(item: menuTableView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item: menuTableView, attribute: .leading, relatedBy: .equal, toItem: menuView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: menuTableView, attribute: .trailing, relatedBy: .equal, toItem: menuView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: menuTableView, attribute: .bottom, relatedBy: .equal, toItem: menuView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        // Activate constraints 
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        
    }
    
}

