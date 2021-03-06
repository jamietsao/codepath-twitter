//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/21/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, UIGestureRecognizerDelegate, ComposeTweetViewDelegate {

    private var tweet: Tweet!
    
    @IBOutlet weak var retweetedBy: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    @IBOutlet weak var retweetedByImageHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedByHeightContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // nav bar customization
        self.navigationItem.title = "Tweet"

        // set up gesture recognizer for reply/retweet/favorite buttons
        var tap = UITapGestureRecognizer(target: self, action: "onTap:")
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
        
        // rounded corners for profile image
        self.profileImage.layer.cornerRadius = 3
        self.profileImage.clipsToBounds = true

        // refresh view
        refreshView()
    }

    func refreshView() {
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
    
    func onTap(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            // get tapped cell
            var view = gestureRecognizer.view!
            var point = gestureRecognizer.locationInView(view)
            
            // perform appropriate action
            if CGRectContainsPoint(self.replyImage.frame, point) {
                
                // get nav controller of the compose view
                let composeNC = self.storyboard?.instantiateViewControllerWithIdentifier("ComposeTweetNavigationController") as
                UINavigationController
                
                // set the delegate of the ComposeTweetViewController to self
                // TODO: this line seems hacky and dangerous - IS THERE A BETTER WAY??
                (composeNC.viewControllers[0] as ComposeTweetViewController).delegate = self
                (composeNC.viewControllers[0] as ComposeTweetViewController).setReplyToTweet(self.tweet!)
                
                // present modally
                self.navigationController?.presentViewController(composeNC, animated: true, completion: nil)
                
            } else if CGRectContainsPoint(self.retweetImage.frame, point) {
                
                // TODO:
                // undo retweet is a bit challenging since I need the id of the retweet, NOT the
                // tweet that was retweeted which is what's returned in timeline.  No unretweeting for now =(
                
                // only allow retweets & only allow if not own tweet
                if !tweet.retweeted! && !tweet.isOwnTweet() {
                    
                    // display action sheet to confirm retweet
                    var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                    
                    // cancel action
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    
                    // reweet action
                    alertController.addAction(UIAlertAction(title: "Retweet", style: .Default,
                        handler: { (action: UIAlertAction!) -> Void in
                            // retweet
                            TwitterClient.sharedInstance.statusRetweet(self.tweet.id!, onComplete: { (tweet, error) -> Void in
                                if error == nil {
                                    // update retweet data in local copy and reload cell
                                    self.tweet.retweeted = true
                                    self.tweet.retweetCount! += 1
                                    self.refreshView()
                                }
                            })
                    }))
                    
                    // present action sheet
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            } else if CGRectContainsPoint(self.favoriteImage.frame, point) {
                
                if tweet.favorited! {
                    // unfavorite
                    TwitterClient.sharedInstance.favoriteDestroy(self.tweet.id!, onComplete: { (tweet, error) -> Void in
                        // update favorite data in local copy and reload cell
                        self.tweet.favorited = false
                        self.tweet.favoriteCount! -= 1
                        self.refreshView()
                    })
                    
                } else {
                    // favorite
                    TwitterClient.sharedInstance.favoriteCreate(self.tweet.id!, onComplete: { (tweet, error) -> Void in
                        // update favorite data in local copy and reload cell
                        self.tweet.favorited = true
                        self.tweet.favoriteCount! += 1
                        self.refreshView()
                    })
                }
                
            } else {
                // should never happen
                NSLog("Unrecognized area tapped!")
            }
        }
    }
    
    func composeTweetView(composeTweetVC: ComposeTweetViewController, didCancel dummy: String) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func composeTweetView(composeTweetVC: ComposeTweetViewController, didTweet tweet: Tweet) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
