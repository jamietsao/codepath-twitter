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
        let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Bordered, target: self, action: "onTweet")
        tweetButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = tweetButton
        
        if let user = User.currentUser {
            self.profileImage.setImageWithURL(NSURL(string: user.profileImageUrl))
            self.name.text = user.name
            self.username.text = user.username
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
        func onComplete(error: NSError!) -> Void {
            if error == nil {
                self.delegate?.composeTweetView(self, didTweet: Tweet(user: User.currentUser!, text: tweetText.text))
            } else {
                // TODO
            }
        }
        
        // POST tweet
        TwitterClient.sharedInstance.statusUpdate(tweetText.text, onComplete)
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
