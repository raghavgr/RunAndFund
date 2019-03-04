//
//  ProfileViewController.swift
//  Run And Fund
//
//  Created by Sai Grandhi on 3/3/19.
//  Copyright © 2019 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileViewController: BackgroundViewController
{
    
    var user:User!
    var charityPerMile:String = ""
    var charityTitle:String = ""
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var charityTitleLabel: UILabel!
    @IBOutlet weak var amntDonated: UILabel!
    
    @IBOutlet var welcomeLabelOutlet: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayWelcomeMessage()

        // Do any additional setup after loading the view.
        // function for retrieving user charity info
        //retriveCharityPerMileDetail()
        print(charityTitle)
        // image icon
        let imageName = "drawkit-content-man-colour"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 20, width:280, height:300)
        view.addSubview(imageView)
        
        // labels
        let email = user.email
        
        emailLabel.text = email
        charityTitleLabel.text = charityTitle
        amntDonated.text = "Donating \(charityPerMile)"
        
    }
    
    
    //Added method retrive charity per mile data  from firebase
    func retriveCharityPerMileDetail()
    {
        let currentUser = Auth.auth().currentUser
        let userID = currentUser?.uid
        
        let demographicReference = Database.database().reference().child(userID!).child("CharityInfo")
        
        
        demographicReference.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists()
            {
                self.charityPerMile = ""
                return
                
            }
            self.charityPerMile = snapshot.childSnapshot(forPath: "charityPerMile").value as! String
            self.charityTitle = snapshot.childSnapshot(forPath: "charityCategory").value as! String
            print(self.charityPerMile)
            print(self.charityTitle)
            
        })
    }
    @IBAction func signOutTapped(_ sender: Any) {
                    SVProgressHUD.show()
                    do
                    {
                        try Auth.auth().signOut()
        
                        // To take user back to rootview i.e the first screen of our app.
        
                        SVProgressHUD.showSuccess(withStatus: "Sucessfully Logged out")
        
                        navigationController?.popToRootViewController(animated: true)
                    }
                    catch
                    {
                        let errorMessage:String = error.localizedDescription.description
        
                        SVProgressHUD.showError(withStatus:errorMessage)
        
                        print(error.localizedDescription)
                    }
    }

    
    func displayWelcomeMessage()
    {
        let name:String = (Auth.auth().currentUser?.displayName)!
        
        welcomeLabelOutlet.text = "Hello, \(String(describing: name))"
    }

}
