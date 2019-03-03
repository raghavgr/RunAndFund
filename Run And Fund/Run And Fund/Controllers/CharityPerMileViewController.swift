//
//  CharityPerMileViewController.swift
//  Run And Fund
//
//  Created by Vikas R S on 3/2/19.
//  Copyright © 2019 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase

class CharityPerMileViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource
{
        let currencyNameArray = ["2"]
    

    @IBOutlet var userNameLabel: UILabel!
    
    var charitySelected: String?
    
    @IBOutlet var charityNameOutlet: UILabel!
    
    @IBOutlet var charityPickerOutlet: UIPickerView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayWelcomeMessage()
        
        charityNameOutlet.text = charitySelected!
        // Do any additional setup after loading the view.
    }
    

    func displayWelcomeMessage()
    {
        let name:String = (Auth.auth().currentUser?.displayName)!
        
        userNameLabel.text = "Hello, \(String(describing: name))"
    }
    
    
   // Picker data source method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }

}
