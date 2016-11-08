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

class TwitterFeedController: SearchBarController {
    
    var menuButton: IconButton!
    var moreButton: IconButton!
    
    let menuWidth = UIScreen.main.bounds.width * (2 / 3)
    var menuView: UIView!
    
    // We need a temp value holder for the constraint as well
    var originalLeadingConstant: CGFloat = 0.0
    var leadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    open override func prepare() {
        super.prepare()
        
        // Prepare out menuview 
        menuView = UIView(frame: CGRect(x: 0, y: searchBar.bounds.height, width: menuWidth, height: self.rootViewController.view.bounds.height))
        
        // Prepare views
        prepareMenuButton()
        prepareMoreButton()
        prepareStatusBar()
        prepareSearchBar()
        preparePanGestureRecognizer()
        prepareMenuView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        // Set the background color to clear
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
                        
                        print("new constant: \(self.originalLeadingConstant + translation.x)")
                        
                        // Now go ahead and set the leading constraint constant 
                        self.leadingConstraint.constant = self.originalLeadingConstant + translation.x
                        
                    },
                    completion: nil)
            }
            
            // Check if the values are negative 
            if (translation.x >= -menuWidth && translation.x <= 0) {
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0.0,
                    options: UIViewAnimationOptions.curveEaseIn, animations: {
                        
                        // Now go ahead and set the leading constraint constant
//                        self.leadingConstraint.constant = self.originalLeadingConstant + translation.x
                        
                    },
                    completion: nil)
            }
            
        } else if panGesture.state == UIGestureRecognizerState.ended {
            
            // If the threshold point is reached then fully animate out the menu view
            if (translation.x <= menuWidth && translation.x >= threshold) {
                
                UIView.animate(
                    withDuration: 0.6,
                    delay: 0.0,
                    options: UIViewAnimationOptions.curveEaseIn, animations: {
                        
                        // Now go ahead and set the leading constraint constant
                        self.leadingConstraint.constant = 0
                        
                    },
                    completion: nil)
                
            } else if (translation.x < threshold) {
                
                UIView.animate(
                    withDuration: 0.6,
                    delay: 0.0,
                    options: UIViewAnimationOptions.curveEaseIn, animations: {
                        
                        // Now go ahead and set the leading constraint constant
                        self.leadingConstraint.constant = self.originalLeadingConstant
                        
                    },
                    completion: nil)
                
            }
            
        }
    }
    
}

extension TwitterFeedController {
    
    internal func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.tintColor = UIColor.white
        menuButton.pulseColor = .white
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
        menuView.backgroundColor = Color.lightBlue.base
        
        // Add as a subview
        view.addSubview(menuView)
                
        let topConstraint = NSLayoutConstraint(item: menuView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: searchBar.bounds.height)
        let bottomConstraint = NSLayoutConstraint(item: menuView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: menuView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: menuWidth)
        leadingConstraint = NSLayoutConstraint(item: menuView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: -menuWidth)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, widthConstraint, leadingConstraint])
    }
    
}

