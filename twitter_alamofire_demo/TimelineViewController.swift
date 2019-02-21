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
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func composeButton(_ sender: Any) {
        
    }
    
    @IBAction func hamburgerButtonTapped(_ sender: Any) {
        if !hamburgerMenuIsVisible {
            tableViewLeadingC.constant = stackView.frame.width
            tableViewTrailingC.constant = stackView.frame.width * -1
            hamburgerMenuIsVisible = true
        } else {
            closeHamburgerMenu()
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
        }
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
    
    
    @IBAction func didTapLogout(_ sender: Any) {
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
    
    // close hamburger menu method for when navigating to any other view
    func closeHamburgerMenu() {
        tableViewLeadingC.constant = 0
        tableViewTrailingC.constant = 0
        hamburgerMenuIsVisible = false
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
