//
//  LoginViewController.swift
//  Run And Fund
//
//  Created by Vikas R S on 3/2/19.
//  Copyright © 2019 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: BackgroundViewController
{

    @IBOutlet var emailIDFieldOutlet: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Below is the code added to dismiss the keyboard.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    // Method to dismiss the keyboard
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    

    @IBAction func loginButtonIsClicked(_ sender: UIButton)
    {
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailIDFieldOutlet.text!, password: passwordField.text!)
        { (result, error) in
            
            if(error != nil)
            {
                let errorMessage:String = (error?.localizedDescription.description)!
                
                SVProgressHUD.showError(withStatus:errorMessage)
                
            }
            else
            {
                SVProgressHUD.showSuccess(withStatus: "Sucessfully Logged In")
                self.performSegue(withIdentifier:"goToMainScreen", sender: self)
            }
        }
    }
    
}
