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

        if let url = tweet.user?.profileImageUrl? {
            self.profileImage.setImageWithURL(NSURL(string: url))
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTweet(tweet: Tweet) {
        self.tweet = tweet
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
