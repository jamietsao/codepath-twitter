//
//  TwitterClient.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/18/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class TwitterClient: BDBOAuth1RequestOperationManager {
   
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "bnmW5KOLtWhBkrsYfvAkXFzpi", consumerSecret: "GcbT1chxNI1asRLS5RlXwbfiHRtztptZ7aqwlfJmGRdZaCgBU3")
        }
        return Static.instance
    }
    
}
