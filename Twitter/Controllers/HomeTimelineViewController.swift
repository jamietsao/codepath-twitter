//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/19/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeTweetViewDelegate {

    var tweets: [Tweet] = []

    // refresh control
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        // set up UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

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
        
        // get tweet for this row and set it in VC
        let tweet = tweets[indexPath.row]
        vc.setTweet(tweet)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func loadTweets(refreshing refresh: Bool) {
        // show progress HUD before invoking API call
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // load latest home timeline
        TwitterClient.sharedInstance.getHomeTimeline { (tweets, error) -> Void in
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
        }
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
        println("About to dismiss Compose View")
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func composeTweetView(composeTweetVC: ComposeTweetViewController, didTweet tweet: Tweet) {
        println("Tweet successfully posted - dismissing Compose View")
        
        // add new tweet to top of timeline before dismissing compose view
        self.tweets.insert(tweet, atIndex: 0)
        self.tableView.reloadData()
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
