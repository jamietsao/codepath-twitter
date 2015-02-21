//
//  Tweet.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/19/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import Foundation

class Tweet {
    
    var user: User?
    var text: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var createdAt: NSDate?

    init(user: User, text: String) {
        self.user = user
        self.text = text
        self.retweetCount = 0
        self.favoriteCount = 0
        self.createdAt = NSDate()
    }
    
    init(dict: NSDictionary) {
        user = User(dict: dict["user"] as NSDictionary)
        text = dict["text"] as? String
        retweetCount = dict["retweet_count"] as? Int
        favoriteCount = dict["favorite_count"] as? Int
        
        // date format: Mon Jan 26 15:24:26 +0000 2009
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(dict["created_at"] as String)
    }

    class func tweetsFromArray(arr: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dict in arr {
            tweets.append(Tweet(dict: dict))
        }
        return tweets
    }
    
}