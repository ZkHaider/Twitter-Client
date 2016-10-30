//
//  Status.swift
//  Twitter-Client
//
//  Created by Haider Khan on 10/30/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    var user: User
    var text: String
    var createdAt: NSDate
    var numberOfRetweets: Int
    var numberOfFavorites: Int
    var mediaImageURL: URL = NSURL() as URL
    
    init(dictionary: NSDictionary) {
        self.user = User(dictionary: dictionary["user"] as! NSDictionary)
        self.text = dictionary["text"] as! String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.date(from: dictionary["created_at"] as! String)! as NSDate
        
        self.numberOfRetweets = dictionary["retweet_count"] as! Int
        self.numberOfFavorites = dictionary["favorite_count"] as! Int
        
        if dictionary["extended_entities"] != nil {
            let extendedDictionary = dictionary["extended_entities"] as! NSDictionary
            let mediaDictionary = extendedDictionary["media"] as! [NSDictionary]
            let mediaUrlString = mediaDictionary[0]["media_url"] as! String
            self.mediaImageURL = NSURL(string: mediaUrlString) as! URL
        }
        
        print(mediaImageURL.absoluteString)
    }
    
    class func statusesWithArray(array: [NSDictionary]) -> [Status] {
        var statuses = [Status]()
        for dictionary in array {
            statuses.append(Status(dictionary: dictionary))
        }
        return statuses
    }

}
