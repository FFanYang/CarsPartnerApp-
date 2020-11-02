//
//  RiderViewController.swift
//  CarsPartnerApp
//
//  Created by Fan Yang on 2/11/20.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import FirebaseAuth



class RiderViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var callaCarButton: UIButton!
    // Use Firebase library to configure APIs
    
    
//CEL LOCATION MANAGER SHOW'S USER'S LOCATION
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var carHasBeencalled = false
 
    
    //set up view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use Firebase library to configure APIs
       

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
                
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with:{(snapshot) in
                self.carHasBeencalled = true
                self.callaCarButton.setTitle("Cancle car", for: .normal)
                Database.database().reference().child("RideRequests").removeAllObservers()
            })
        }
        // Do any additional setup after loading the view.
    }
    
    //Did update locations any time
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            //update our actual user location is going to be
            userLocation = center
            //Map to show user's location
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.01))
            //update map
            map.setRegion(region, animated: true)
            //remove all the previous annotation from the map
            map.removeAnnotations(map.annotations)
            //Make annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your location"
            map.addAnnotation(annotation)
            
            }
        }
    
    
    @IBAction func callCarTapped(_ sender: Any) {
        if let email = Auth.auth().currentUser?.email {
            
            if carHasBeencalled {
                carHasBeencalled = false
                callaCarButton.setTitle("Call a vehicle", for: .normal)
                Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: {(snapshot) in
                    snapshot.ref.removeValue()
                    Database.database().reference().child("RideRequests").removeAllObservers()
                })
                    
            } else {
                let rideRequestDictionary : [String:Any] = ["email":email,"lat":userLocation.latitude,"lon":userLocation.longitude]
                Database.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictionary)
                callaCarButton.setTitle("Cancle Calling Vehicle", for: .normal)
            }
        
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
        
        
    }
    
   
    

}
