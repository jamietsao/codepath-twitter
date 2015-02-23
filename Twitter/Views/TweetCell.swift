//
//  TweetCell.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/19/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    var tweet: Tweet!
    
    @IBOutlet weak var retweetedBy: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteCount: UILabel!

    @IBOutlet weak var retweetedByImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedByHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        // rounded corners for profile image
        self.profileImage.layer.cornerRadius = 3
        self.profileImage.clipsToBounds = true

        self.tweetText.preferredMaxLayoutWidth = self.tweetText.frame.size.width
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.tweetText.preferredMaxLayoutWidth = self.tweetText.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setTweet(tweet: Tweet) {
        self.tweet = tweet
        
        // show original tweet info if a retweet
        var displayTweet = tweet
        if tweet.isRetweet() {
            displayTweet = tweet.retweetedTweet!

            // retweeted by user of this tweet
            if let name = tweet.user?.name {
                self.retweetedBy.text = name + " retweeted"
            }
            self.retweetedByImageHeightConstraint.constant = 10
            self.retweetedByHeightConstraint.constant = 10
            
        } else {
            self.retweetedByImageHeightConstraint.constant = 0
            self.retweetedByHeightConstraint.constant = 0
        }
        
        // profile image
        if let url = displayTweet.user?.getProfileUrlBigger() {
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
        
        // relative created date
        self.createdAt.text = displayTweet.getCreatedAtRelativeDisplay()
        
        // retweet info
        if displayTweet.retweeted! {
            self.retweetImage.image = UIImage(named: "Retweeted")
        } else {
            self.retweetImage.image = UIImage(named: "Retweet")
        }
        // if own tweet, reduce alpha to indicate that you can't retweet own tweet
        if displayTweet.isOwnTweet() {
            self.retweetImage.alpha = 0.2
        } else {
            self.retweetImage.alpha = 1.0
        }
        
        if displayTweet.retweetCount == 0 {
            // don't show 0's
            self.retweetCount.hidden = true
        } else {
            self.retweetCount.hidden = false
            self.retweetCount.text = String(displayTweet.retweetCount!)
        }

        // favorite info
        if displayTweet.favorited! {
            self.favoriteImage.image = UIImage(named: "Favorited")
        } else {
            self.favoriteImage.image = UIImage(named: "Favorite")
        }
        if displayTweet.favoriteCount == 0 {
            // don't show 0's
            self.favoriteCount.hidden = true
        } else {
            self.favoriteCount.hidden = false
            self.favoriteCount.text = String(displayTweet.favoriteCount!)
        }
        
    }
    
}
