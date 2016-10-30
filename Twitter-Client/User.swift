//
//  User.swift
//  Twitter-Client
//
//  Created by Haider Khan on 10/30/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {

    var name: String
    var screenName: String
    var profileImageURL: NSURL
    var tagline: String
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        self.name = dictionary["name"] as! String
        self.screenName = dictionary["screen_name"] as! String
        
        let profileImageUrlString = dictionary["profile_image_url"] as! String
        let modifiedString = profileImageUrlString.replacingOccurrences(of: "_normal", with: "_bigger")
        self.profileImageURL = NSURL(string: modifiedString)!
        
        self.tagline = dictionary["description"] as! String
    }
    
    func logout() {
        
        User.currentUser = nil
        
        // Log out user from twitter client 
        
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = UserDefaults.standard.object(forKey: currentUserKey) as? NSData
                if data != nil {
                    let userDictionary = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary
                    if userDictionary != nil {
                        _currentUser = User(dictionary: userDictionary!!)
                    }
                }
            }
            
            return _currentUser
            
        } set (user) {
            _currentUser = user
            
            if _currentUser != nil {
                if let userData = try! JSONSerialization.data(withJSONObject: user!.dictionary, options: []) as? NSData {
                    UserDefaults.standard.set(userData, forKey: currentUserKey)
                }
            } else {
                UserDefaults.standard.set(nil, forKey: currentUserKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
    
}
