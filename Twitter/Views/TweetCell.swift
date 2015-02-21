//
//  TweetCell.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/19/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    private var tweet: Tweet!
    
    @IBOutlet weak var profileImageUrl: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
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
        self.retweetCount.text = String(tweet.retweetCount!)
        self.favoriteCount.text = String(tweet.favoriteCount!)
    }
    
}
