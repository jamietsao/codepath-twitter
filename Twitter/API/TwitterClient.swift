//
//  TwitterClient.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/18/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class TwitterClient: BDBOAuth1RequestOperationManager {
   
    var onCompletionHandler: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "bnmW5KOLtWhBkrsYfvAkXFzpi", consumerSecret: "GcbT1chxNI1asRLS5RlXwbfiHRtztptZ7aqwlfJmGRdZaCgBU3")
        }
        return Static.instance
    }

    //
    // REST API (https://dev.twitter.com/rest/public)
    //

    func statusUpdate(tweet: String, onComplete: (error: NSError!) -> Void) {
        // set up params
        let params = [ "status" : tweet ]
        
        // invoke API
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                onComplete(error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error while POSTing status update: \(error)")
                onComplete(error: error)
            }
        )
    }
    
    func getHomeTimeline(onComplete: (tweets: [Tweet]!, error: NSError!) -> Void) {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweets = Tweet.tweetsFromArray(response as [NSDictionary])
                onComplete(tweets: tweets, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Failed to retrieve tweets: \(error)")
                onComplete(tweets: nil, error: error)
            }
        )
    }
    
    //
    // OAuth 1.0a
    //
    
    func login(onCompletion: (user: User?, error: NSError?) -> ()) {
        // save completion handler
        onCompletionHandler = onCompletion;

        // remove previous access token and kickoff OAuth dance
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "jttwitter://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error: NSError!) -> Void in
                println("Error getting request token: \(error)")
                self.onCompletionHandler!(user: nil, error: error)
            }
        )
    }
    
    func handleCallback(url: NSURL) {
        // TODO: need to check if user denied access?
        
        // access granted so fetch access token
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                // save access token
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                // retrieve user via REST API
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        var user = User(dict: response as NSDictionary)
                        User.currentUser = user
                        println("Logged in as: \(user.username)")

                        // invoke completion handler with user
                        self.onCompletionHandler!(user: user, error: nil)
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        NSLog("Failed to retrieve user: \(error)")
                        self.onCompletionHandler!(user: nil, error: error)
                    }
                )
            
            },
            failure: { (error: NSError!) -> Void in
                NSLog("Failed to get access token!")
                self.onCompletionHandler!(user: nil, error: error)
            }
        )
    }
    
    
}
