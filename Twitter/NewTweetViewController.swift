//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Eyoel Wendwosen on 3/12/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // forces the keyboard to apear as the view loads.
        tweetTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onPostButton(_ sender: Any) {
        
        if (!tweetTextView.text.isEmpty) {
            let tweetPostUrl = "https://api.twitter.com/1.1/statuses/update.json"
            let newTweetText =  tweetTextView.text!
            TwitterAPICaller.client?.postNewTweet(url: tweetPostUrl, status: newTweetText, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { Error in
                print("Cound't post tweet due to: \(Error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
            print("Empty text can't post tweet.")
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
