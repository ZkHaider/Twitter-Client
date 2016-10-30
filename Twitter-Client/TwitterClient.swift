//
//  TwitterClient.swift
//  Twitter-Client
//
//  Created by Haider Khan on 10/30/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "txPNYIAkB8j6z6rWItCFEWToG"
let twitterConsumerSecret = "CCu6w7LmYJ6vCfHk31Ae3oIW5Wn2Jq2lDKC9QqzlXFRpNxKhf1"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((_ user: User?, _ error: NSError?) -> ())?
    
    class var instance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL as URL!, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }
    
    // MARK: - User
    
    func homelineWithParams(params: NSDictionary?, completion: @escaping (_ statuses: [Status]?, _ error: NSError?) -> ()) {
        self.get("1.1/statuses/home_timeline.json", parameters: params, success: { (operation, response) in
            
            print(response)
            let statuses = Status.statusesWithArray(array: response as! [NSDictionary])
            completion(statuses, nil)
            
        }, failure: { (operation, error) in
            
            print(error.localizedDescription)
            print("Error getting home timeline")
            completion(nil, error as NSError?)
            
        })
    }
    
    // MARK: - Login

    func loginWithCompletion(completion: @escaping (_ user: User?, _ error: NSError?) -> ()) {
     
        self.loginCompletion = completion
        TwitterClient.instance.requestSerializer.removeAccessToken()
        TwitterClient.instance.fetchRequestToken(
                withPath: "oauth/request_token",
                method: "GET",
                callbackURL: NSURL(string: "zkhaider://oauth") as URL!,
                scope: nil,
                success: { (credential) in
            
                print("Got the token")
                if let requestCredential = credential! as? BDBOAuth1Credential {
                    // Use request token to get access token
                    let requestToken = requestCredential.token
                    print(requestToken!)
                    let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!)") as! URL
                    UIApplication.shared.open(authURL, options: [:], completionHandler: { (success) in
                     
                        if success {
                            print("Got it")
                        } else {
                            print("not success ")
                        }
                    })
                }
            
            
            }, failure: { (error) in
            
                print("Failed to get request token")
                self.loginCompletion?(nil, error as NSError?)
            })
    }
    
    func openURL(url: URL) {
        
        let credential = BDBOAuth1Credential(queryString: url.query)
        
        self.fetchAccessToken(withPath: "oauth/access_token",
                              method: "POST",
                              requestToken: credential,
                              success: { (credential) in
                                
                                    print("Got the access token")
                                
                                    // Save access token
                                    TwitterClient.instance.requestSerializer.saveAccessToken(credential)
                                
                                    // Verify user
                                    TwitterClient.instance.get("1.1/account/verify_credentials.json", parameters: nil, success: { (operation, response) in
                                    
                                        let user = User(dictionary: response as! NSDictionary)
                                        User.currentUser = user
                                        print("User: \(user.name)")
                                        self.loginCompletion!(user, nil)
                                        
                                    }, failure: { (operation, error) in
                                    
                                        print("error getting current user")
                                        self.loginCompletion!(nil, error as NSError?)
                                    })
                                
                              }, failure: { (error) in
                                
                                    print("Failed to receive access token")
                                    self.loginCompletion?(nil, error as NSError?)
                              })
    }
}
