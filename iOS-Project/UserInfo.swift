//
//  UserInfo.swift
//  iOS-Project
//
//  Created by Rambo Wu on 11/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase

class UserInfo
{
    var email: String?
    var highScore: Int?
    var points: Int?
    
    init(snapshot: FIRDataSnapshot)
    {
        let snapshotValue = snapshot.value as! NSDictionary
        self.email = snapshotValue.value(forKey: "email") as! String?
        self.highScore = snapshotValue.value(forKey: "highScore") as! Int?
        self.points = snapshotValue.value(forKey: "points") as! Int?
    }
    
    init(email: String, highScore: Int, points: Int)
    {
        self.email! = email
        self.highScore! = highScore
        self.points! = points
    }
}
