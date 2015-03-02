//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/28/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeTweetViewDelegate {

    // current user
    var user: User!

    // user profile outlets
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!

    // current array of Tweets backing the table view
    var tweets: [Tweet] = []

    // table view of tweets
    @IBOutlet weak var tableView: UITableView!
    
    // refresh control
    var refreshControl: UIRefreshControl!

    // menu button delegate
    var menuButtonDelegate: MenuButtonDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // customize nav bar & back button
        self.navigationItem.title = self.user?.name
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let backButton = UIBarButtonItem(title: nil, style: .Bordered, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)], forState: UIControlState.Normal)
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
        
        // add menu nav button
        let menuButton = UIBarButtonItem(image: UIImage(named: "Menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "onMenuButton")
        menuButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = menuButton
        
        // banner image
        if let url = self.user?.profileBannerUrl {
            self.bannerImage.setImageWithURL(NSURL(string: url))
        }
        
        // profile image
        if let url = self.user?.getProfileUrlOriginal() {
            self.profileImage.setImageWithURL(NSURL(string: url))
        }
        self.profileImage.layer.cornerRadius = 3
        self.profileImage.clipsToBounds = true
        
        // name
        self.name.text = self.user?.name
        
        // username
        if let username = self.user?.username {
            self.username.text = "@" + username
        }
        
        // stats
        if let count = self.user?.tweetCount {
            self.tweetCount.text = String(count)
        }
        if let count = self.user?.followingCount {
            self.followingCount.text = String(count)
        }
        if let count = self.user?.followerCount {
            self.followerCount.text = String(count)
        }
        
        // initialize table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // set up UIRefreshControl
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
//        tableView.insertSubview(refreshControl, atIndex: 0)

        // register custom cells
        var cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: "TweetCell")
        
        // load tweets
        loadTweets(refreshing: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUser(user: User) {
        self.user = user
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
        TwitterClient.sharedInstance.getTimeline(Constants.TimelineViewType.User, userId: self.user.id
            , onComplete: { (tweets, error) -> Void in
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

    func onMenuButton() {
        self.menuButtonDelegate.onMenuButton(self)
    }

}
