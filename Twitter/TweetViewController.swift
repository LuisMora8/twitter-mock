//
//  TweetViewController.swift
//  Twitter
//
//  Created by Luis Mora on 2/25/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var characterLimitLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder() //shows textview is ready
        
        tweetTextView.delegate = self
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if(!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let characterLimit = 280
        
        //construct new text if we allowed the users latest edit
        let newText = NSString(string: tweetTextView.text!).replacingCharacters(in: range, with: text)
        
        //updating the character limit
        characterLimitLabel.text = "\(characterLimit - newText.count)"
        
        //the new text should be allowed?
        return newText.count < characterLimit
    }

}
