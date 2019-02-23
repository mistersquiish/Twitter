//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate {

    var tweets: [Tweet] = []
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    // constraints for tableView
    @IBOutlet weak var tableViewLeadingC: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailingC: NSLayoutConstraint!
    
    var hamburgerMenuIsVisible = false
    var user: User! = User.current

    @IBOutlet weak var hamburgerMenuView: UIView!
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    @IBOutlet var followerCountLabel: UILabel!
    
    @IBOutlet weak var profileButtonOutlet: UIButton!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    
    @IBAction func composeButton(_ sender: Any) {
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        
        nameLabel.text = user.name
        screenNameLabel.text = "@" + user.screenName
        profileImageView.af_setImage(withURL: user.profileImageUrl)
        followerCountLabel.text = String(user.followersCount)
        followingCountLabel.text = String(user.followingsCount)
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderWidth = 0
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func hamburgerButtonTapped(_ sender: Any) {
        if !hamburgerMenuIsVisible {
            openHamburgerMenu()
        } else {
            closeHamburgerMenu()
        }
    }
    
    @IBAction func swipeRightGesture(_ sender: Any) {
        if !hamburgerMenuIsVisible {
            openHamburgerMenu()
        }
        
        
    }
    
    @IBAction func swipeLeftGesture(_ sender: Any) {
        if hamburgerMenuIsVisible {
            closeHamburgerMenu()
        }
    }
    
    // close hamburger menu method for when navigating to any other view
    func closeHamburgerMenu() {
        tableViewLeadingC.constant = 0
        tableViewTrailingC.constant = 0
        hamburgerMenuIsVisible = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
        }
    }
    
    // open hamburger menu method for reusable code
    func openHamburgerMenu() {
        tableViewLeadingC.constant = hamburgerMenuView.frame.width
        tableViewTrailingC.constant = hamburgerMenuView.frame.width * -1
        hamburgerMenuIsVisible = true
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
        }
    }
    
    // logout
    @IBAction func logoutButton(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    
    // refresh controll
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    // ComposeViewControllerDelegate protocol method
    func did(post: Tweet) {
        refreshControlAction(refreshControl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "composeSegue" {
            let destinationViewController = segue.destination as! ComposeViewController
            destinationViewController.delegate = self
        } else if segue.identifier == "tweetDetailSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let tweet = tweets[indexPath.row]
                let destinationViewController = segue.destination as! TweetDetailViewController
                destinationViewController.tweet = tweet
            }
            
        }
        closeHamburgerMenu()
    }
}
