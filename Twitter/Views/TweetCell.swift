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

    
    @IBAction func onTap(sender: AnyObject) {
        println("Tapped!")
    }
    
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

        // Configure the view for the selected state
    }

    func setTweet(tweet: Tweet) {
        self.tweet = tweet
        
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
        
        // relative created date
        self.createdAt.text = tweet.getCreatedAtRelativeDisplay()
        
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
        if tweet.retweetCount == 0 {
            // don't show 0's
            self.retweetCount.hidden = true
        } else {
            self.retweetCount.hidden = false
            self.retweetCount.text = String(tweet.retweetCount!)
        }

        // favorite info
        if tweet.favorited! {
            self.favoriteImage.image = UIImage(named: "Favorited")
        } else {
            self.favoriteImage.image = UIImage(named: "Favorite")
        }
        if tweet.favoriteCount == 0 {
            // don't show 0's
            self.favoriteCount.hidden = true
        } else {
            self.favoriteCount.hidden = false
            self.favoriteCount.text = String(tweet.favoriteCount!)
        }
        
    }
    
}
