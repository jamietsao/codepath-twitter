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
    var id: String?
    var text: String?
    var retweeted: Bool?
    var retweetCount: Int?
    var favorited: Bool?
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
        id = dict["id_str"] as? String
        text = dict["text"] as? String
        retweeted = dict["retweeted"] as? Bool
        retweetCount = dict["retweet_count"] as? Int
        favorited = dict["favorited"] as? Bool
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
    
    func getCreatedAtDisplay() -> String {
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return formatter.stringFromDate(self.createdAt!)
    }
    
    func getCreatedAtRelativeDisplay() -> String {
        // get elapsed durations
        let elapsed = Int(NSDate().timeIntervalSinceDate(self.createdAt!))
        let days: Int = elapsed / 86400
        let hours: Int = elapsed / 3600
        let minutes: Int = elapsed / 60
        
        if days > 6 {
            // show date if beyond 6 days
            var formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            return formatter.stringFromDate(self.createdAt!)
        } else if days > 0 {
            return "\(days)d"
        } else if hours > 0 {
            return "\(hours)h"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(elapsed)s"
        }
    }
    
}