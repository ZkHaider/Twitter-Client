//
//  String.swift
//  Twitter-Client
//
//  Created by Haider Khan on 11/7/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import Foundation

extension String {
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }

    
}
