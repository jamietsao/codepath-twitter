//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/19/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // load tweets
        loadTweets(refreshing: false)
    }

    func onRefresh() {
        // load tweets
        loadTweets(refreshing: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetCell
        
        // get tweet for this row
        let tweet = tweets[indexPath.row]
        if let url = tweet.user?.profileImageUrl? {
            cell.profileImageUrl.setImageWithURL(NSURL(string: url))
        }
        cell.name.text = tweet.user?.name
        cell.username.text = tweet.user?.username
        cell.tweetText.text = tweet.text
        cell.retweetCount.text = String(tweet.retweetCount!)
        cell.favoriteCount.text = String(tweet.favoriteCount!)
        return cell
    }

    func loadTweets(refreshing refresh: Bool) {
        // show progress HUD before invoking API call
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // retrieve user via REST API
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                self.networkErrorLabel.hidden = true
                self.tweets = Tweet.tweetsFromArray(response as [NSDictionary])
                if refresh {
                    self.refreshControl.endRefreshing()
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.tableView.reloadData()
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Failed to retrieve tweets: \(error)")
            }
        )
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        self.navigationController?.performSegueWithIdentifier("ComposeSegue", sender: self)
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
