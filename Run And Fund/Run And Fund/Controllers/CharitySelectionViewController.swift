//
//  CharitySelectionViewController.swift
//  Run And Fund
//
//  Created by Vikas R S on 3/2/19.
//  Copyright © 2019 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class CharitySelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    let baseURL = "https://data.orghunter.com/v1/categories?user_key="
    let APP_ID = "dd27482e8293f445c4bcf895428745fe"
    
    @IBOutlet var tableViewOutlet: UITableView!
    var charitySelected:String = ""
    
    
    var charityArray:[String] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        SVProgressHUD.show()
        getCharityData(url:"\(baseURL)\(APP_ID)")
        navigationItem.hidesBackButton = true

    }
    
    
    
    // Table view data source methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return charityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "\(charityArray[indexPath.row])"
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        return cell
    }
    
    
    //Table View delegate method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         charitySelected = charityArray[indexPath.row]
        
        let alert = UIAlertController(title:"Thank You!!!", message:"You have selected \(charitySelected) as your charity category", preferredStyle:.alert)
        
        let alertOKAction = UIAlertAction(title:"OK", style:.default)
        { (alertAction) in
        
            self.performSegue(withIdentifier:"goToCharityConfig", sender: nil)
        }
        
        let alertCancelAction = UIAlertAction(title:"Cancel", style:.cancel)
 
        
        alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        
        self.present(alert,animated:true)
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    func getCharityData(url:String)
    {
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                print("We are Succcessfully able to call the Charity service.")
                
                let charityDataJSON :JSON = JSON(response.result.value!)
                
                var i = 0
                
                for charity in charityDataJSON["data"]
                {
                    
                    let charityStringValue = charity.1["categoryDesc"].stringValue
                    
                    if(charityStringValue == "" || charityStringValue == "Not Provided")
                    {
                        continue
                    }
                    
                    self.charityArray.insert(charityStringValue, at:i)
                    
                    i = i + 1

                }

                self.tableViewOutlet.reloadData()
                
                SVProgressHUD.dismiss()
            }
            
            if (response.result.isFailure)
            {
                print("Its a failure to call the charity URL \(String(describing: response.result.error))")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "goToCharityConfig")
        {
            // getting instance of secondViewController
            let destination = segue.destination as! CharityPerMileViewController
            
            // setting data to screen 2 variable
            destination.charitySelected = charitySelected
        }
    }
    
    


}
