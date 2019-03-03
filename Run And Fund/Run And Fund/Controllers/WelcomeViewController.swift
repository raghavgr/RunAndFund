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
        
        addGradientToView(view: self.view)
        
        // image icon
        let imageName = "icon-left-font-monochrome-black"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 60, y: 120, width:300, height:300)
        view.addSubview(imageView)
        
        
        
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

    func addGradientToView(view: UIView)
    {
        //gradient layer
        let gradientLayer = CAGradientLayer()
        
        //define colors
        let colorTop = UIColor(red: 255.0 / 255.0, green: 226.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0 / 255.0, green: 167.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        //gradientLayer.locations = [0.5, 0.6, 0.8]
        
        //define frame
        gradientLayer.frame = view.bounds
        gradientLayer.zPosition = -1
        //insert the gradient layer to the view layer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}

