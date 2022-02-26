//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Luis Mora on 2/19/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    //members of the TweetCell
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    
    var liked:Bool = false
    var retweeted:Bool = false
    var tweetID:Int = -1
    
    @IBAction func likeTweet(_ sender: Any) {
        let toBeLiked = !liked
        
        if (toBeLiked) {
            TwitterAPICaller.client?.likeTweet(tweetID: tweetID, success: {
                self.setLike(true)
            }, failure: {(Error) in
                print("Favorite did not succeed \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unlikeTweet(tweetID: tweetID, success: {
                print("liked")
                self.setLike(false)
            }, failure: { (Error) in
                print("Unfavorite did not succeed \(Error)")
            })
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
        
        let toBeRetweeted = !retweeted
        
        if (toBeRetweeted) {
            TwitterAPICaller.client?.retweet(tweetID: tweetID, success: {
                self.setRetweeted(true)
            }, failure: { Error in
                print("Favorite did not succeed \(Error)")
            })
        } else {
            TwitterAPICaller.client?.retweet(tweetID: tweetID, success: {
                print("retweeted")
                self.setRetweeted(false)
            }, failure: { (Error) in
                print("Retweet did not succeed \(Error)")
            })
        }
        
    }
    
    func setLike( _ isLiked:Bool) {
        liked = isLiked
        
        if(liked) {
            likeButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            likeButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted( _ isRetweeted:Bool) {
        retweeted = isRetweeted
        
        if(retweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
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

}
