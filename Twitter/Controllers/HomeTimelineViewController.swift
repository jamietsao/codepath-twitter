//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/19/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, ComposeTweetViewDelegate, ContainerViewDelegate {

    // container open/closed state
    var opened: Bool = false
    
    // view type
    var viewType: Constants.TimelineViewType!
    
    // current array of Tweets backing the table view
    var tweets: [Tweet] = []

    // refresh control
    var refreshControl: UIRefreshControl!

    // menu button delegate
    var menuButtonDelegate: MenuButtonDelegate!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize nav bar & back button
        self.navigationItem.title = Constants.Menu.MenuViewTypeTitle[viewType]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let backButton = UIBarButtonItem(title: nil, style: .Bordered, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)], forState: UIControlState.Normal)
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton

        // add menu nav button
        let menuButton = UIBarButtonItem(image: UIImage(named: "Menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "onMenuButton")
        menuButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = menuButton
        
        // initialize table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRectZero)

        // set up UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        // set up gesture recognizer for reply/retweet/favorite buttons
        var tap = UITapGestureRecognizer(target: self, action: "onTap:")
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.tableView.addGestureRecognizer(tap)
        
        // register custom cells
        var cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: "TweetCell")

        // load tweets
        loadTweets(refreshing: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func onRefresh() {
        // load tweets
        loadTweets(refreshing: true)
    }

    func onTap(gestureRecognizer: UIGestureRecognizer) {
        
        // if this view is slide open, close view via delegate
        if self.opened {
            self.opened = false
            self.menuButtonDelegate.onMenuButton(self, open: false)
            return
        }
        
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            // get tapped cell
            var tableView = gestureRecognizer.view as UITableView
            var point = gestureRecognizer.locationInView(tableView)
            var indexPath = tableView.indexPathForRowAtPoint(point)
            var cell = tableView.cellForRowAtIndexPath(indexPath!) as TweetCell
            
            // get associated tweet
            var thisTweet = self.tweets[indexPath!.row]
            
            // perform appropriate action
            var pointInCell = gestureRecognizer.locationInView(cell)
            if CGRectContainsPoint(cell.profileImage.frame, pointInCell) {
                
                // get user corresponding to tapped profile
                var user = thisTweet.isRetweet() ? thisTweet.retweetedTweet?.user : thisTweet.user
                
                // get profile view controller
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.IDs.ProfileViewController) as ProfileViewController
                
                vc.setUser(user!)
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if CGRectContainsPoint(cell.replyImage.frame, pointInCell) {

                // get nav controller of the compose view
                let composeNC = self.storyboard?.instantiateViewControllerWithIdentifier("ComposeTweetNavigationController") as
                UINavigationController
                
                // set the delegate of the ComposeTweetViewController to self
                // TODO: this line seems hacky and dangerous - IS THERE A BETTER WAY??
                (composeNC.viewControllers[0] as ComposeTweetViewController).delegate = self
                (composeNC.viewControllers[0] as ComposeTweetViewController).setReplyToTweet(thisTweet)
                
                // present modally
                self.navigationController?.presentViewController(composeNC, animated: true, completion: nil)
                
            } else if CGRectContainsPoint(cell.retweetImage.frame, pointInCell) {
                
                // TODO:
                // undo retweet is a bit challenging since I need the id of the retweet, NOT the
                // tweet that was retweeted which is what's returned in timeline.  No unretweeting for now =(
                
                // only allow retweets & only allow if not own tweet
                if !thisTweet.retweeted! && !thisTweet.isOwnTweet() {
                
                    // display action sheet to confirm retweet
                    var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                    
                    // cancel action
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    
                    // reweet action
                    alertController.addAction(UIAlertAction(title: "Retweet", style: .Default,
                        handler: { (action: UIAlertAction!) -> Void in
                            // retweet
                            TwitterClient.sharedInstance.statusRetweet(cell.tweet.id!, onComplete: { (tweet, error) -> Void in
                                if error == nil {
                                    // update retweet data in local copy and reload cell
                                    thisTweet.retweeted = true
                                    thisTweet.retweetCount! += 1
                                    tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
                                }
                            })
                    }))
                    
                    // present action sheet
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            } else if CGRectContainsPoint(cell.favoriteImage.frame, pointInCell) {
                
                if thisTweet.favorited! {
                    // unfavorite
                    TwitterClient.sharedInstance.favoriteDestroy(cell.tweet.id!, onComplete: { (tweet, error) -> Void in
                        // update favorite data in local copy and reload cell
                        thisTweet.favorited = false
                        thisTweet.favoriteCount! -= 1
                        tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
                    })
                    
                } else {
                    // favorite
                    TwitterClient.sharedInstance.favoriteCreate(cell.tweet.id!, onComplete: { (tweet, error) -> Void in
                        // update favorite data in local copy and reload cell
                        thisTweet.favorited = true
                        thisTweet.favoriteCount! += 1
                        tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
                    })
                }
                
            } else {
                // should never happen
                NSLog("Unrecognized area tapped!")
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        // if this view is slid open, allow touch gesture
        if self.opened {
            return true
        }
        
        // get tapped cell
        var tableView = gestureRecognizer.view as UITableView
        var point = touch.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        if indexPath != nil {
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as TweetCell
            
            // only handle tap gesture if reply/retweet/favorite images were tapped
            point = touch.locationInView(cell)
            if CGRectContainsPoint(cell.replyImage.frame, point) ||
                CGRectContainsPoint(cell.retweetImage.frame, point) ||
                CGRectContainsPoint(cell.favoriteImage.frame, point) ||
                CGRectContainsPoint(cell.profileImage.frame, point){
                    return true
            } else {
                return false
            }
        }
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetCell

        // get tweet for this row and set it in the cell
        let tweet = tweets[indexPath.row]
        cell.setTweet(tweet)
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TweetDetailsViewController") as TweetDetailsViewController

        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // get tweet for this row and set it in VC
        let tweet = tweets[indexPath.row]
        vc.setTweet(tweet)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        // get nav controller of the compose view
        let composeNC = self.storyboard?.instantiateViewControllerWithIdentifier("ComposeTweetNavigationController") as
        UINavigationController
        
        // set the delegate of the ComposeTweetViewController to self
        // TODO: this line seems hacky and dangerous - IS THERE A BETTER WAY??
        (composeNC.viewControllers[0] as ComposeTweetViewController).delegate = self

        // present modally
        self.navigationController?.presentViewController(composeNC, animated: true, completion: nil)
    }
    
    func composeTweetView(composeTweetVC: ComposeTweetViewController, didCancel dummy: String) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func composeTweetView(composeTweetVC: ComposeTweetViewController, didTweet tweet: Tweet) {
        // add new tweet to top of timeline before dismissing compose view
        self.tweets.insert(tweet, atIndex: 0)
        self.tableView.reloadData()
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadTweets(refreshing refresh: Bool) {
        // show progress HUD before invoking API call
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // load latest home timeline
        TwitterClient.sharedInstance.getTimeline(self.viewType, userId: nil, onComplete: { (tweets, error) -> Void in
            if error == nil {
                //                self.networkErrorLabel.hidden = true
                self.tweets = tweets
                if refresh {
                    self.refreshControl.endRefreshing()
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.tableView.reloadData()
            } else {
                NSLog("Failed to retrieve tweets: \(error)")
                // TODO: display error
            }
        })
    }
    
    func setViewType(viewType: Constants.TimelineViewType) {
        self.viewType = viewType
    }
    
    func onMenuButton() {
        self.opened = !self.opened
        self.menuButtonDelegate.onMenuButton(self, open: self.opened)
    }
    
    func didSlideOpen() {
        self.opened = true
    }
    
    func didSlideClosed() {
        self.opened = false
    }
}
