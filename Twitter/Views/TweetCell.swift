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
    
    @IBOutlet weak var profileImageUrl: UIImageView!
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
        
        if let url = tweet.user?.profileImageUrl? {
            self.profileImageUrl.setImageWithURL(NSURL(string: url))
        }
        self.name.text = tweet.user?.name
        if let username = tweet.user?.username {
            self.username.text = "@" + username
        }
        self.tweetText.text = tweet.text
        if tweet.retweeted! {
            self.retweetImage.image = UIImage(named: "Retweeted")
        } else {
            self.retweetImage.image = UIImage(named: "Retweet")
        }
        self.retweetCount.text = String(tweet.retweetCount!)
        if tweet.favorited! {
            self.favoriteImage.image = UIImage(named: "Favorited")
        } else {
            self.favoriteImage.image = UIImage(named: "Favorite")
        }
        self.favoriteCount.text = String(tweet.favoriteCount!)
    }
    
}
