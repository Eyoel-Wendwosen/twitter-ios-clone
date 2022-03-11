//
//  LoginViewController.swift
//  Twitter
//
//  Created by Eyoel Wendwosen on 3/9/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "twitterUserLoggedIn") == true {
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        let tokenUrl = "https://api.twitter.com/oauth/request_token"
        
        
        TwitterAPICaller.client?.login(url: tokenUrl, success: {
            UserDefaults.standard.set(true, forKey: "twitterUserLoggedIn")
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }, failure: { Error in
            print(Error)
        })
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
