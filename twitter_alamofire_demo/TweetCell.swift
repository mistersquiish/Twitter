//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var replyCountLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBAction func replyButton(_ sender: Any) {
    }
    
    @IBAction func retweetButton(_ sender: Any) {
    }
 
    @IBAction func favoriteButton(_ sender: Any) {
        
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
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.user.name
            screenNameLabel.text = "@" + tweet.user.screenName
            createdDateLabel.text = tweet.createdAtString
            profileImage.af_setImage(withURL: tweet.user.profileImageUrl)
            if tweet.favorited {
                favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            }
            retweetCountLabel.text = String(describing: tweet.retweetCount)
            favoriteCountLabel.text = String(describing: tweet.favoriteCount)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshData() {
        tweetTextLabel.text = tweet.text
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@" + tweet.user.screenName
        createdDateLabel.text = tweet.createdAtString
        profileImage.af_setImage(withURL: tweet.user.profileImageUrl)
        if tweet.favorited {
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        retweetCountLabel.text = String(describing: tweet.retweetCount)
        favoriteCountLabel.text = String(describing: tweet.favoriteCount)
    }
    
}
