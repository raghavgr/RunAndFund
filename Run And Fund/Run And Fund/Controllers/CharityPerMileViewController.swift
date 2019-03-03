//
//  CharityPerMileViewController.swift
//  Run And Fund
//
//  Created by Vikas R S on 3/2/19.
//  Copyright © 2019 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CharityPerMileViewController: BackgroundViewController, UIPickerViewDelegate,UIPickerViewDataSource
{

    
        let charityPerMileArray = ["$0.25/mile","$0.5/mile","$1.00/mile", "$1.25/mile", "$1.50/mile", "$1.75/mile","$2.00/mile", "$2.50/mile","$3.00/mile", "$3.50/mile","$4.00/mile","$4.50/mile","$5.00/mile"]
    

    @IBOutlet var userNameLabel: UILabel!
    
    var charitySelected: String?
    
    var charityAmountSelected:String = ""
    
    @IBOutlet var charityNameOutlet: UILabel!
    
    @IBOutlet var charityPickerOutlet: UIPickerView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayWelcomeMessage()
        
        charityNameOutlet.text = charitySelected!
        // Do any additional setup after loading the view.
        
        charityPickerOutlet.dataSource = self
        charityPickerOutlet.delegate = self
    }
    

    func displayWelcomeMessage()
    {
        let name:String = (Auth.auth().currentUser?.displayName)!
        
        userNameLabel.text = "Hello, \(String(describing: name))"
    }
    
    //MARK: - Picker Data Source methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return charityPerMileArray.count
    }
    
    //MARK: - Picker Delegate methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return charityPerMileArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        charityAmountSelected = charityPerMileArray[row]
    }
    
    
    
    
    @IBAction func submitButtonClicked(_ sender: UIButton)
    {
        SVProgressHUD.show()
        let userUID:String = (Auth.auth().currentUser?.uid)!
        
        let userCharityDatabase = Database.database().reference().child(userUID).child("CharityInfo")
        
        let userCharityDictionary = ["charityCategory":charitySelected!,
                                         "charityPerMile":charityAmountSelected] as [String : Any]
        
        userCharityDatabase.setValue(userCharityDictionary)
        {
            (error,reference ) in
            
            if(error != nil)
            {
                SVProgressHUD.showError(withStatus:"Error while storing Charity information!!!")
            }
            else
            {
                SVProgressHUD.showSuccess(withStatus:"Sucessfully saved Charity information.")
                self.performSegue(withIdentifier: "goToMainScreen", sender: self)
            }
            
        }
        
    }
    

}
