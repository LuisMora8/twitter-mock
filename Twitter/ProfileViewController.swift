//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Luis Mora on 2/26/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user = NSDictionary()
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUserProfile()
    }
    
    //load tweets when home page has appeared
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //load the profile
        self.loadUserProfile()
    }
    
    @objc func loadUserProfile() {
        let url = "https://api.twitter.com/1.1/account/verify_credentials.json"
        let params = ["include_email": true]

        TwitterAPICaller.client?.getDictionaryRequest(url: url, parameters: params as [String : Any], success: { NSDictionary in
            self.user = NSDictionary
        }, failure: { Error in
            print("Error getting user \"Error")
        })
        
        nameLabel.text = user["name"] as? String
        handleLabel.text = user["screen_name"] as? String
        bioLabel.text = user["description"] as? String
        
        print(user)
        
        friendsCount.text = "\(user["friends_count"] ?? "") Following"
        followerCount.text = "\(user["followers_count"] ?? "") Followers"
        likeCount.text = "\(user["favourites_count"] ?? "") Likes"
        
        if(user["profile_image_url"] != nil) {
            let imageUrl = URL(string: ((user["profile_image_url"] as? String)!))
            let data = try? Data(contentsOf: imageUrl!)
            if let imageData = data {profileImageView.image = UIImage(data: imageData)
            }
        }
        
        if(user["profile_banner_url"] != nil) {
            let imageUrl = URL(string: ((user["profile_banner_url"] as? String)!))
            let data = try? Data(contentsOf: imageUrl!)
            if let imageData = data {headerImageView.image = UIImage(data: imageData)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
