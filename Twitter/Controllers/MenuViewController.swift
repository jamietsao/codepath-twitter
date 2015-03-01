//
//  MenuViewController.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/27/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // positions to help with menu animation
    var firstPan = true
    var originalCenter: CGPoint!
    var openPosition: CGPoint!
    var closePosition: CGPoint!
    
    // current index path and view controller
    var currentIndexPath: NSIndexPath!
    var currentVC: UIViewController!

    // container for current view
    @IBOutlet weak var containerView: UIView!
    
    // menu view (beneath container view)
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // default to home timeline
        switchViews(Constants.Menu.HomeIndex)

        // initialize open/close positions
        closePosition = self.containerView.center
        openPosition = CGPointMake(containerView.center.x + (containerView.frame.width * 0.8), containerView.center.y)
     
        // initialize table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // register custom cells
        var cellNib = UINib(nibName: Constants.IDs.MenuUserCell, bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: Constants.IDs.MenuUserCell)
        cellNib = UINib(nibName: Constants.IDs.MenuItemCell, bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: Constants.IDs.MenuItemCell)
        
        // bring container view to front
        self.view.bringSubviewToFront(self.containerView)

        // select "Home" by default
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: Constants.Menu.HomeIndex, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
        setSelectedMenuItem(NSIndexPath(forRow: Constants.Menu.HomeIndex, inSection: 0))
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.Menu.MenuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let row = indexPath.row
        if row == Constants.Menu.HeaderIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.IDs.MenuUserCell) as MenuUserCell
            cell.setUser(User.currentUser!)
            cell.userInteractionEnabled = false // do allow selection for header cell
            return cell
        } else {
            let menuItemLabel = Constants.Menu.MenuItems[row]
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.IDs.MenuItemCell) as MenuItemCell
            cell.titleLabel.text = menuItemLabel
            return cell
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        // perform logout
        if indexPath.row == Constants.Menu.LogOutIndex {
            TwitterClient.sharedInstance.logout()
            
            
            self.storyboard.in
            
            self.performSegueWithIdentifier("logoutSegue", sender: self)
        } else {
            // deselect previous
            if self.currentIndexPath != nil {
                tableView.deselectRowAtIndexPath(self.currentIndexPath, animated: true)
            }
            
            // keep track of currently selected indexPath
            self.currentIndexPath = indexPath
            
            // customize cell selection color
            setSelectedMenuItem(indexPath)
            
            // animate container view to closed position and show new view
            UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
                self.containerView.center = self.closePosition
                self.switchViews(indexPath.row)
                }, completion: nil)
        }
    }
    
    func switchViews(menuItemIndex: Int) {
        
        // TODO: double check this
        // remove old view from container
        if let vc = self.currentVC {
            vc.willMoveToParentViewController(nil)
            vc.view.removeFromSuperview()
            vc.didMoveToParentViewController(nil)
        }
        
        // initialize new view
        var nc: UINavigationController
        if menuItemIndex == Constants.Menu.ProfileIndex {
            nc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.IDs.ProfileNavigationController) as UINavigationController
            let vc = nc.topViewController as ProfileViewController
            vc.setUser(User.currentUser!)
        } else {
            nc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.IDs.HomeTimelineNavigationController) as UINavigationController
            let vc = nc.topViewController as HomeTimelineViewController
            vc.setViewType(Constants.Menu.MenuViewtypes[menuItemIndex - 2])
        }
        
        // add new view into container
        self.addChildViewController(nc)
        nc.view.frame = self.containerView.frame
        self.containerView.addSubview(nc.view)
        nc.didMoveToParentViewController(self)
        self.currentVC = nc
    }
    
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Began {
            originalCenter = self.containerView.center
            if firstPan {
                closePosition = self.containerView.center
                openPosition = CGPointMake(containerView.center.x + (containerView.frame.width * 0.8), containerView.center.y)
                firstPan = false
            }
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            var location = sender.locationInView(self.view)
            var translation = sender.translationInView(self.view)
            var velocity = sender.velocityInView(self.view)
            
//            println("location: \(location)")
//            println("translation: \(translation)")
//            println("velocity: \(velocity)")
            
            if (self.containerView.frame.minX <= 0 && translation.x < 0) {
                // do nothing
            } else {
                self.containerView.center = CGPointMake(self.originalCenter.x + translation.x, self.originalCenter.y)
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            var velocity = sender.velocityInView(self.view)
            
            if velocity.x > 0 {
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
                    self.containerView.center = self.openPosition
                    }, completion: nil)
                
            } else {
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
                    self.containerView.center = self.closePosition
                    }, completion: nil)
            }
        }
        
    }
    
    func setSelectedMenuItem(indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor(red: 102/255, green: 117/255, blue: 127/255, alpha: 1)
    }
    
}
