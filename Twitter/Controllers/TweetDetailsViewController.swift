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
    
    @IBOutlet weak var retweetedBy: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    @IBOutlet weak var retweetedByImageHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedByHeightContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // rounded corners for profile image
        self.profileImage.layer.cornerRadius = 3
        self.profileImage.clipsToBounds = true

        // show original tweet info if a retweet
        var displayTweet = tweet
        if tweet.isRetweet() {
            displayTweet = tweet.retweetedTweet!
            
            // retweeted by user of this tweet
            if let name = tweet.user?.name {
                self.retweetedBy.text = name + " retweeted"
            }

        } else {
            self.retweetedByImageHeightContraint.constant = 0
            self.retweetedByHeightContraint.constant = 0
        }
        
        // profile image
        if let url = displayTweet.user?.profileImageUrl? {
            self.profileImage.setImageWithURL(NSURL(string: url))
        }
        
        // name
        self.name.text = displayTweet.user?.name
        
        // username
        if let username = displayTweet.user?.username {
            self.username.text = "@" + username
        }
        
        // tweet
        self.tweetText.text = displayTweet.text
        
        // created date
        self.createdAt.text = displayTweet.getCreatedAtDisplay()
        
        // retweet info
        if displayTweet.retweeted! {
            self.retweetImage.image = UIImage(named: "Retweeted")
        } else {
            self.retweetImage.image = UIImage(named: "Retweet")
        }
        // if own tweet, reduce alpha to indicate that you can't retweet own tweet
        if displayTweet.isOwnTweet() {
            self.retweetImage.alpha = 0.2
        }
        self.retweetCount.text = String(displayTweet.retweetCount!)
        
        // favorite info
        if displayTweet.favorited! {
            self.favoriteImage.image = UIImage(named: "Favorited")
        } else {
            self.favoriteImage.image = UIImage(named: "Favorite")
        }
        self.favoriteCount.text = String(displayTweet.favoriteCount!)
        
    }

    func setTweet(tweet: Tweet) {
        self.tweet = tweet
    }
    
}
