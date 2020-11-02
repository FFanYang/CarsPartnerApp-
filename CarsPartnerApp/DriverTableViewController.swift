//
//  DriverTableViewController.swift
//  CarsPartnerApp
//
//  Created by Fan Yang on 2/11/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class DriverTableViewController: UITableViewController, CLLocationManagerDelegate {

    
    var rideRequests : [DataSnapshot] = []
    var locationManager = CLLocationManager()
    var driverLocation = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        Database.database().reference().child("RideRequests").observe(.childAdded)
        {(snapshot) in
            if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                if let driverlat = rideRequestDictionary["driverLat"] as? Double {
                    
                } else {
                    self.rideRequests.append(snapshot)
                    self.tableView.reloadData()
                    
                }
                
                
            }
           
        }
        //Timer setting
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer) in
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rideRequests.count
    }

    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)

        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            driverLocation = coord
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "riderReuestCell", for: indexPath)

        
        let snashot = rideRequests[indexPath.row]
        
        if let rideRequestDictionary = snashot.value as? [String:AnyObject] {
        if let email = rideRequestDictionary["email"] as? String {
            //How far away driver
            if let lat = rideRequestDictionary["lat"] as? Double {
                if let lon = rideRequestDictionary["lon"] as? Double {
                    
                    let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                    let riderCLLlocation = CLLocation(latitude: lat, longitude: lon)
                    let distance = driverCLLocation.distance(from:
                    riderCLLlocation)/1000
                    let roundedDistance = round(distance * 100)/100
                    
                    
                    
                    cell.textLabel?.text = "\(email) - \(roundedDistance)km away"
                    
                }
                
            }
            
            
            
            
            
        }
        }
        
        //To see cell is working or not
       

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let snashot = rideRequests[indexPath.row]
        performSegue(withIdentifier: "acceptSegue", sender: snashot)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? AcceptRequestViewController{
            if let snapshot = sender as? DataSnapshot{
                
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                if let email = rideRequestDictionary["email"] as? String {
                    //How far away driver
                    if let lat = rideRequestDictionary["lat"] as? Double {
                        if let lon = rideRequestDictionary["lon"] as? Double {
                            acceptVC.requestEmail = email
                            
                            let location = CLLocationCoordinate2D(
                            latitude: lat, longitude: lon
                            )
                            acceptVC.requestLocation = location
                            acceptVC.driverLocation = driverLocation
                        }
                    }
                }
                    
                }
                
            }
        }
    }
   
   

}
