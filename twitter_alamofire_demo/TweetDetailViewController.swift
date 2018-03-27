//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Henry Vuong on 3/26/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextField: UITextView!
    
    @IBOutlet weak var retweetLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var retweetButtonOutlet: UIButton!
    
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    var tweet: Tweet!
    
    @IBAction func retweetButton(_ sender: Any) {
        if tweet.retweeted {
            APIManager.shared.unRetweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.tweet.retweeted = false
                    self.tweet.retweetCount -= 1
                    self.refreshData()
                }
            }
        } else {
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.tweet.retweeted = true
                    self.tweet.retweetCount += 1
                    self.refreshData()
                }
            }
        }
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        if tweet.favorited {
            APIManager.shared.unFavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.tweet.favorited = false
                    self.tweet.favoriteCount -= 1
                    self.refreshData()
                }
            }
        } else {
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.tweet.favorited = true
                    self.tweet.favoriteCount += 1
                    self.refreshData()
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData() {
        tweetTextField.text = tweet.text
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@" + tweet.user.screenName
        photoView.af_setImage(withURL: tweet.user.profileImageUrl)
        if tweet.favorited {
            favoriteButtonOutlet.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            favoriteButtonOutlet.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        if tweet.retweeted {
            retweetButtonOutlet.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            retweetButtonOutlet.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        retweetLabel.text = String(describing: tweet.retweetCount)
        favoritesLabel.text = String(describing: tweet.favoriteCount)
    }
    
}
