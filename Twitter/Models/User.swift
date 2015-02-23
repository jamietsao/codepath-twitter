//
//  User.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/19/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import Foundation

var _currentUser: User?

class User {

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey("CurrentUser") as? NSData
                if data != nil {
                    var dict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dict: dict)
                }
            }
            return _currentUser
        }
        set(user) {
            // set current user
            _currentUser = user

            // save to NSUserDefaults
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dict, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: "CurrentUser")
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "CurrentUser")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    var dict: NSDictionary
    var id: String!
    var name: String!
    var username: String!
    var profileImageUrl: String!
    
    init(dict: NSDictionary) {
        self.dict = dict
        id = dict["id_str"] as? String
        name = dict["name"] as? String
        username = dict["screen_name"] as? String
        profileImageUrl = dict["profile_image_url"] as? String
    }

    func getProfileUrlBigger() -> String {
        if let url = self.profileImageUrl {
            return self.profileImageUrl.stringByReplacingOccurrencesOfString("normal", withString: "bigger")
        }
        return ""
    }

}