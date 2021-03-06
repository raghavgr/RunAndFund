//
//  RunMainScreenViewController.swift
//  Run And Fund
//
//  Created by Vikas R S on 3/3/19.
//  Copyright © 2019 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SVProgressHUD
import Firebase

class RunMainScreenViewController: BackgroundViewController
{
    
    // Start & Run View configurations
    @IBOutlet weak var introLabel: UIView!
    @IBOutlet weak var unitsView: UIView!
    
    // Unit labels that need to be updated
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    // Start & Stop Buttons
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var run:Run?
    private let locationManager = LocationManager.shared
    private var region:MKCoordinateRegion?
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    private var charityPerMile:String = ""
    private var charityTitle:String = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.mapView.setRegion(region!, animated: true)
        navigationItem.hidesBackButton = true
        
        //Added method retrive charity per mile data  from firebase
        retriveCharityPerMileDetail()
        unitsView.isHidden = true
        startButton.layer.cornerRadius = 30
        startButton.clipsToBounds = true
        stopButton.layer.cornerRadius = 30
        stopButton.clipsToBounds = true
        stopButton.layer.zPosition = 1
        
        if (CLLocationManager.locationServicesEnabled() == true) {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
    }
    
    @IBAction func startTapped(_ sender: Any) {
        startRun()
    }
    
    @IBAction func stopTapped(_ sender: Any) {
        stopRun()
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.stopRun()
            self.saveRun()
            self.performSegue(withIdentifier: .details, sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.stopRun()
            //_ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    private func startRun() {
        mapView.removeOverlays(mapView.overlays)
        introLabel.isHidden = true
        unitsView.isHidden = false
        startButton.isHidden = true
        stopButton.isHidden = false
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun() {
        introLabel.isHidden = false
        unitsView.isHidden = true
        startButton.isHidden = false
        stopButton.isHidden = true
        if let coor = locationManager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coor.latitude, longitude: coor.longitude)
            self.mapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        }
        locationManager.stopUpdatingLocation()
    }
    
    private func startLocationUpdates() {
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 1
    }
    
    private func saveRun() {
        let newRun = Run(context: CoreDataStack.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.timestamp = Date()
        
        //Added code to save data to firebase
        saveRunToFireBase(distanceValue: distance.value, durationValue: Int16(seconds))
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRun.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        
        run = newRun
    }
    
    
    @IBAction func logoutIsClicked(_ sender: UIBarButtonItem)
    {
        self.performSegue(withIdentifier: .profile, sender: nil)
//            SVProgressHUD.show()
//            do
//            {
//                try Auth.auth().signOut()
//
//                // To take user back to rootview i.e the first screen of our app.
//
//                SVProgressHUD.showSuccess(withStatus: "Sucessfully Logged out")
//
//                navigationController?.popToRootViewController(animated: true)
//            }
//            catch
//            {
//                let errorMessage:String = error.localizedDescription.description
//
//                SVProgressHUD.showError(withStatus:errorMessage)
//
//                print(error.localizedDescription)
//            }
        
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
            
        })
    }

    func saveRunToFireBase(distanceValue:Double , durationValue:Int16)
    {
        SVProgressHUD.show()
        let userUID:String = (Auth.auth().currentUser?.uid)!
        
        let timestampValue = Date().currentTimeMillis()

        
        let userCharityDatabase = Database.database().reference().child(userUID).child(String(timestampValue!))
        
        let userCharityDictionary = ["distanceRan":distanceValue,
                                     "duration":durationValue] as [String : Any]
        
        userCharityDatabase.setValue(userCharityDictionary)
        {
            (error,reference ) in
            
            if(error != nil)
            {
                SVProgressHUD.showError(withStatus:"Error while storing Run Distance information!!!")
            }
            else
            {
                SVProgressHUD.showSuccess(withStatus:"Sucessfully saved Run Distance information.")
            }
            
        }
    }
    
}


extension RunMainScreenViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "RunDetailedViewController"
        case profile = "showProfile"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! RunDetailedViewController
            destination.run = run
            destination.donationAmount = charityPerMile
        case .profile:
            let destination = segue.destination as! ProfileViewController
            destination.user = Auth.auth().currentUser
            destination.charityTitle = self.charityTitle
            destination.charityPerMile = self.charityPerMile
        }
        
    }
}

extension RunMainScreenViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
             self.region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region!, animated: true)
        }

        
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)

            }
            
            locationList.append(newLocation)
        }
    }
}

extension Date {
    func currentTimeMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension RunMainScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
