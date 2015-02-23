//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/21/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

protocol ComposeTweetViewDelegate: class {
    func composeTweetView(composeTweetVC: ComposeTweetViewController, didCancel dummy: String)
    func composeTweetView(composeTweetVC: ComposeTweetViewController, didTweet tweet: Tweet)
}

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    // in reply to tweet (nil if composing new tweet)
    var replyToTweet: Tweet!
    var replyToTweetId: String!
    
    // delegate
    weak var delegate: ComposeTweetViewDelegate?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var whatsHappening: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize nav bar
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "onCancel")
        cancelButton.tintColor = UIColor.whiteColor()
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)], forState: UIControlState.Normal)
        let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Bordered, target: self, action: "onTweet")
        tweetButton.tintColor = UIColor.whiteColor()
        tweetButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)], forState: UIControlState.Normal)
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = tweetButton

        // rounded corners for profile image
        self.profileImage.layer.cornerRadius = 3
        self.profileImage.clipsToBounds = true

        // set values from current user
        if let user = User.currentUser {
            self.profileImage.setImageWithURL(NSURL(string: user.getProfileUrlBigger()))
            self.name.text = user.name
            self.username.text = "@" + user.username
        }
        
        // if replying, start tweet text with username of tweet author
        if replyToTweet != nil {
            if let username = replyToTweet.user?.username {
                self.whatsHappening.hidden = true
                self.tweetText.text = "@" + username + " "
                self.tweetText.becomeFirstResponder()
            }
        }
        
        tweetText.delegate = self
    }

    func textViewDidBeginEditing(textView: UITextView) {
        self.whatsHappening.hidden = true
    }
    
    func onCancel() {
        self.delegate?.composeTweetView(self, didCancel: "")
    }
    
    func onTweet() {
        // handler
        func onComplete(tweet: Tweet!, error: NSError!) -> Void {
            if error == nil {
                self.delegate?.composeTweetView(self, didTweet: tweet)
            } else {
                // TODO
            }
        }
        
        // POST tweet
        TwitterClient.sharedInstance.statusUpdate(tweetText.text, onComplete)
    }
    
    func setReplyToTweet(tweet: Tweet) {
        self.replyToTweet = tweet;
        self.replyToTweetId = tweet.id
    }
}
