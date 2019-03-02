//
//  WelcomeViewController.swift
//  Run And Fund
//
//  Created by Vikas R S on 3/2/19.
//  Copyright © 2019 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class WelcomeViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // changes made to show error in dark mode
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setFont(UIFont.boldSystemFont(ofSize: 17))
        SVProgressHUD.setMaximumDismissTimeInterval(0.5)
        
        // Below code is added to keep user logged in even when user quits the app.
        let currentUser = Auth.auth().currentUser
        
        Auth.auth().addStateDidChangeListener
            {
                (auth, user) in
                
                if (user == currentUser && user != nil)
                {
                    self.performSegueFunc()
                }
                
        }
    
    }
    
    func performSegueFunc()
    {
        self.performSegue(withIdentifier:"goToGetStarted" , sender: self)
    }


}

