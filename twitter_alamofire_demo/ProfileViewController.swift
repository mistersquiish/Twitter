//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Henry Vuong on 3/27/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileView: UIImageView!
    
    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    var user: User! = User.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = user.name
        self.screenNameLabel.text = user.screenName
        profileView.af_setImage(withURL: user.profileImageUrl)
        backgroundView.af_setImage(withURL: user.backgroundImageUrl)
        followerCountLabel.text = String(user.followersCount)
        followingCountLabel.text = String(user.followingsCount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
