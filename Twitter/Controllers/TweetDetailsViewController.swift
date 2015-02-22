//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/21/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    private var tweet: Tweet!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // rounded corners for profile image
        self.profileImage.layer.cornerRadius = 3
        self.profileImage.clipsToBounds = true

        // profile image
        if let url = tweet.user?.profileImageUrl? {
            self.profileImage.setImageWithURL(NSURL(string: url))
        }
        
        // name
        self.name.text = tweet.user?.name
        
        // username
        if let username = tweet.user?.username {
            self.username.text = "@" + username
        }
        
        // tweet
        self.tweetText.text = tweet.text
        
        // created date
        self.createdAt.text = tweet.getCreatedAtDisplay()
        
        // retweet info
        if tweet.retweeted! {
            self.retweetImage.image = UIImage(named: "Retweeted")
        } else {
            self.retweetImage.image = UIImage(named: "Retweet")
        }
        // if own tweet, reduce alpha to indicate that you can't retweet own tweet
        if tweet.isOwnTweet() {
            self.retweetImage.alpha = 0.2
        }
        self.retweetCount.text = String(tweet.retweetCount!)
        
        // favorite info
        if tweet.favorited! {
            self.favoriteImage.image = UIImage(named: "Favorited")
        } else {
            self.favoriteImage.image = UIImage(named: "Favorite")
        }
        self.favoriteCount.text = String(tweet.favoriteCount!)
        
    }

    func setTweet(tweet: Tweet) {
        self.tweet = tweet
    }
    
}
