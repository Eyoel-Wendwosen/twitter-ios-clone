//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Eyoel Wendwosen on 3/10/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {

    @IBOutlet weak var HomeNavigationItem: UINavigationItem!
    
    var tweetsArray = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Logo change
        /*
        let logo = UIImage(named: "TwitterLogoBlue")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        */
        
        loadTweets()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func loadTweets() {
        
        let tweetRequestUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let tweetRequestParamteters = ["count": 15]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetRequestUrl, parameters: tweetRequestParamteters, success: { (tweets: [NSDictionary]) in
            self.tweetsArray.removeAll()
            for tweet in tweets {
                self.tweetsArray.append(tweet)
            }
            
            self.tableView.reloadData()
        }, failure: { Error in
            print("Error can't load the tweets")
        })
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "twitterUserLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweetsArray[indexPath.row]
        let user = tweet["user"] as! [String:Any]
        let userProfileImageUrl = user["profile_background_image_url_https"] as? String
        
        if userProfileImageUrl != nil {
            cell.userProflieImageView.af.setImage(withURL: userProfileImageUrl)
        }
        
        
        cell.userNamelabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweet["text"] as? String
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
