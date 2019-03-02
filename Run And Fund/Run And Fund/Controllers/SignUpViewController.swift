//
//  SignUpViewController.swift
//  Run And Fund
//
//  Created by Vikas R S on 3/2/19.
//  Copyright © 2019 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet var nameFieldOutlet: UITextField!
    
    
    @IBOutlet var emailIDFieldOutlet: UITextField!
    
    @IBOutlet var passwordFieldOutlet: UITextField!
    
    @IBOutlet var signUpButtonOutlet: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Below is the code added to dismiss the keyboard.

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // changes made to show error in dark mode
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setFont(UIFont.boldSystemFont(ofSize: 17))
        SVProgressHUD.setMaximumDismissTimeInterval(0.5)

    }
    
    // Method to dismiss the keyboard
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }

    @IBAction func signUpButtonIsClicked(_ sender: UIButton)
    {
        // To verify if name field is blank
        if((nameFieldOutlet.text?.count)! == 0)
        {
            SVProgressHUD.showError(withStatus: "Name cannot be left blank")
            return
            
        }
        
        
        if let emailID = emailIDFieldOutlet.text
        {
            // To verify if name field is blank or if email id is valid or not
            if (emailID.count == 0)
            {
                SVProgressHUD.showError(withStatus: "Email ID field cannot be left blank!!!")
                return
            }
            else if !(self.isValidEmail(testStr: emailID))
            {
                SVProgressHUD.showError(withStatus: "Email ID entered is not Valid")
                return
            }
        }
        
        //To verify if password is atleast 6 characters
        if((passwordFieldOutlet.text?.count)! < 6)
        {
            SVProgressHUD.showError(withStatus: "Password must be at least 6 characters long!!!")
            return
            
        }
        
        SVProgressHUD.show()
        
        guard let email:String = emailIDFieldOutlet.text else {return}
        guard let password:String = passwordFieldOutlet.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password)
        { (authResult, error) in
            if (error != nil)
            {
                let errorMessage:String = (error?.localizedDescription.description)!
                
                SVProgressHUD.showError(withStatus:errorMessage)
                
                print(error!)
            }
            else
            {
                print("Message Sucessfully saved.")
                self.profileModification()
                
            }
            
        }
        
        
    }
    
    // function to check if email id is valid.
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    // Once signup is successful this method is called to update the name and
    func profileModification()
    {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = self.nameFieldOutlet.text!
        
        changeRequest?.commitChanges(completion:
            {
                error in
                
                if ((error) != nil)
                {
                    let errorMessage:String = (error?.localizedDescription.description)!
                    
                    SVProgressHUD.showError(withStatus:errorMessage)
                    
                }
                else
                {
                    SVProgressHUD.showSuccess(withStatus: "Thank You! You have sucessfully signed up!")
                    self.performSegue(withIdentifier:"goToGetStarted" , sender: self)
                }
                
        })
        
        
    }
    
}
