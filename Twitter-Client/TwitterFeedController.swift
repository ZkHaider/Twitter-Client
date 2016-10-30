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
    
    private var menuButton: IconButton!
    private var moreButton: IconButton!
    
    open override func prepare() {
        super.prepare()
        prepareMenuButton()
        prepareMoreButton()
        prepareStatusBar()
        prepareSearchBar()
    }
    
    private func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.tintColor = UIColor.white
        menuButton.pulseColor = .white
    }
    
    private func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreVertical)
        moreButton.tintColor = UIColor.white
        moreButton.pulseColor = .white
        
        moreButton.addTarget(self, action: #selector(morePressed), for: .touchUpInside)
    }
    
    private func prepareStatusBar() {
        
        statusBarStyle = .lightContent
            
        // Access the statusBar
        self.statusBarController?.statusBar.backgroundColor = Color.blue.base
    }
    
    private func prepareSearchBar() {
        
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func dismissKeyboard() {
        searchBar.textField.text = ""
        searchBar.endEditing(true)
    }
    
    @objc private func morePressed() {
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
    
}

