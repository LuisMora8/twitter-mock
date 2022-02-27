//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Luis Mora on 2/19/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    //array to hold tweets, given as dictionaries
    var tweetArray = [NSDictionary]()
    //variable to add more tweets to the page when needed
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load tweets when refresh is performed
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150

    }
    
    //load tweets when home page has appeared
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //load the first tweets
        self.loadTweets()
    }
    
    @objc func loadTweets(){
        //default tweets for the home page
        numberOfTweets = 20
        //base url for setting up the home timeline
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        //using api to see the dictionaries of the tweets
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            //reloading tweets into array
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            //reusing table views
            self.tableView.reloadData()
            //ending the refresh ti prevent infinite refresh
            self.myRefreshControl.endRefreshing()
            
        }, failure: { Error in
            print("Could not retreive tweets!")
        })
    }
    
    func loadMoreTweets(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        //adding more tweets to the page
        numberOfTweets += 20
        let myParams = ["count": numberOfTweets]
        
        //same logic as loadtweets function
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { Error in
            print("Could not retreive tweets!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //when the user reaches the end of the page call load more tweets
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    

    @IBAction func onLogout(_ sender: Any) {
        //when logout button is pressed, logout and dismiss screen
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reusing table view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet Cell", for: indexPath) as! TweetCellTableViewCell
        //setting up the text of the userlabel with the user name
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as? String
        //setting up the text of the tweetlabel with the tweet text content
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        //setting up the image view with the data from of the profile url image
        let imageUrl = URL(string: ((user["profile_image_url_https"] as? String)!))
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setLike(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetID = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returning the array count to display all the tweets as seperate rows
        return tweetArray.count
    }


}
