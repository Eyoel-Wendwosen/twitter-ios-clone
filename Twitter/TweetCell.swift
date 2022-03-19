//
//  TweetCell.swift
//  Twitter
//
//  Created by Eyoel Wendwosen on 3/10/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import WebKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userProflieImageView: UIImageView!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    
    var tweetId: Int = -1
    var favCount: Int = -1
    var retweetCount: Int = -1
    var isFavorited: Bool = false
    var isRetweeted: Bool = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        let toBeFavorited = !isFavorited
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.favCount += 1
                self.favCountLabel.text = self.formatNumber(num: self.favCount)
                self.setFavoriteButtonIcon(true)
                self.isFavorited = true
            }, failure: { (error) in
                print("Favorite not successful: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.favCount -= 1
                self.favCountLabel.text = self.formatNumber(num: self.favCount)
                self.setFavoriteButtonIcon(false)
                self.isFavorited = false
                
            }, failure: { (error) in
                print("UnFavorite not successful: \(error)")
            })
        }
            }
    
    @IBAction func onRetweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: { (response) in
            self.isRetweeted = true
            self.retweetCount += 1
            self.retweetCountLabel.text = self.formatNumber(num: self.retweetCount)
            self.setRetweetButtonIcon(true)
        }, failure: { (error) in
            print("Retweet not successful: \(error)")
        })
        
        
    }
    
    
    func setFavoriteButtonIcon(_ favorited: Bool) {
        if (favorited) {
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweetButtonIcon(_ retweeted: Bool) {
        if (retweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        userProflieImageView.layer.borderWidth = 1
        userProflieImageView.layer.masksToBounds = false
        userProflieImageView.layer.borderColor = UIColor.white.cgColor
        userProflieImageView.layer.cornerRadius = (imageView?.image?.size.height ?? 40.0) / 2
        userProflieImageView.clipsToBounds = true
        // Configure the view for the selected state
        self.selectionStyle  = UITableViewCell.SelectionStyle.none
    }
    
    func formatRelativeTime(isoTime: String) -> String {
        
        let dateForamtter = DateFormatter()
        dateForamtter.locale = Locale(identifier: "en_US_POSIX")
        // created_at": "Wed Oct 10 20:19:24 +0000 2018
        dateForamtter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        let date = dateForamtter.date(from: isoTime)
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .full
        var string = relativeFormatter.localizedString(for: date!, relativeTo: Date())
        string = string.replacingOccurrences(of: "days", with: "d")
        string = string.replacingOccurrences(of: "day", with: "d")
        string = string.replacingOccurrences(of: "months", with: "m")
        string = string.replacingOccurrences(of: "month", with: "m")
        string = string.replacingOccurrences(of: "weeks", with: "w")
        string = string.replacingOccurrences(of: "week", with: "w")
        string = string.replacingOccurrences(of: "year", with: "y")
        string = string.replacingOccurrences(of: "years", with: "y")
        string = string.replacingOccurrences(of: "minutes", with: "m")
        string = string.replacingOccurrences(of: "minute", with: "m")
        string = string.replacingOccurrences(of: "seconds", with: "s")
        string = string.replacingOccurrences(of: "second", with: "s")
        string = string.replacingOccurrences(of: " ", with: "")
        string = string.replacingOccurrences(of: "ago", with: "")
        
        return string
    }
    
    func formatNumber(num: Int) -> String {
        let number = Double(num)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(num)"
        }
    }
    
    func configure(tweet: NSDictionary) {
        // set up tweet Id
        tweetId = tweet["id"] as! Int
        
        // get user details
        let user = tweet["user"] as! [String:Any]
        let userProfileImageUrl = user["profile_image_url_https"] as? String
        
        // set user profile
        if userProfileImageUrl != nil {
            let imageURL = URL(string: userProfileImageUrl!)
            userProflieImageView.af.setImage(withURL: imageURL!)
        }

        // set tweet text and user name
        userNamelabel.text = user["name"] as? String
        tweetContentLabel.text = tweet["text"] as? String
        
        // setup favorite
        isFavorited = tweet["favorited"] as! Bool
        setFavoriteButtonIcon(isFavorited)
        
        // setup retweeted
        isRetweeted = tweet["retweeted"] as! Bool
        setRetweetButtonIcon(isRetweeted)
        
        // tweet Date
        let time = tweet["created_at"] as! String
        timeStampLabel.text = formatRelativeTime(isoTime: time)
        
        // fav and retweet count
        let _favCount = tweet["favorite_count"] as! Int
        favCount = _favCount
        let _retweetCount = tweet["retweet_count"] as! Int
        retweetCount = _retweetCount
        
        if (_favCount > 0) {
            favCountLabel.text = formatNumber(num: _favCount)
        } else {
            favCountLabel.text = ""
        }
        if (_retweetCount > 0) {
            retweetCountLabel.text = formatNumber(num: retweetCount)
        } else {
            retweetCountLabel.text = ""
        }
    }

                
                
}
