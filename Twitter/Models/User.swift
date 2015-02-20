//
//  User.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/19/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import Foundation

class User {
    
    var name: String!
    var username: String!
    var profileImageUrl: String!
    
    init(dict: NSDictionary) {
        name = dict["name"] as? String
        username = dict["screen_name"] as? String
        profileImageUrl = dict["profile_image_url"] as? String
    }
    
}