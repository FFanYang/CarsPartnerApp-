//
//  ViewController.swift
//  CarsPartnerApp
//
//  Created by Fan Yang on 9/10/20.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var drivelabel: UILabel!
    
    @IBOutlet weak var Riderlabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var driverRiderSwitch: UISwitch!
    
    @IBOutlet weak var topButton: UIButton!
    
    @IBOutlet weak var bottomButton: UIButton!
    
    var SignUpMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func topTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
         displayAlert(title: "Missing Information", message: "You must provide both a email and password")
            
        }else{
            if let email = emailTextField.text{
                if let password = passwordTextField.text{
                    
            //check and see whether they're trying to sign up or to log in
            if SignUpMode{
               //Sign UP != not equa
             
                Auth.auth().createUser(withEmail: email, password: password, completion: {(User,error) in
                    if error != nil{
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    }      else{
                        if self.driverRiderSwitch.isOn {
                            //Driver sign up
                           let req = Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Rider"
                            req?.commitChanges(completion: nil)
                            self.performSegue(withIdentifier: "riderSegue", sender: nil)
                            
                        } else {
                            //Rider sign up
                            let req = Auth.auth().currentUser?.createProfileChangeRequest()
                             req?.displayName = "driver"
                             req?.commitChanges(completion: nil)
                            self.performSegue(withIdentifier: "driverSegue", sender: nil)
                            
                        }
           
                    }
                    
                })
            }else {
                // Log In
                Auth.auth().signIn(withEmail: email, password: password, completion: {(User,error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                        
                    }else{
                        let User = Auth.auth().currentUser?.createProfileChangeRequest()
                        if User?.displayName == "Rider"{
                            
                            //Driver
                            self.performSegue(withIdentifier: "riderSegue", sender: nil)
                            
                        } else {
            
                            //Rider
                            self.performSegue(withIdentifier: "driverSegue", sender: nil)
                        
                        }
                        
                    }
                })
                
            }
                }
            }
            
        }
        
        
    }
    //alert to user & use alert Controller
    func displayAlert(title: String, message:String ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func buttomTapped(_ sender: Any) {
        if SignUpMode {
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Switch to Sign up", for: .normal)
            Riderlabel.isHidden = true
            drivelabel.isHidden = true
            driverRiderSwitch.isHidden = true
            SignUpMode = false
            
        }else{
            topButton.setTitle("Sign UP", for: .normal)
            bottomButton.setTitle("Switch to Log In", for: .normal)
            Riderlabel.isHidden = false
            drivelabel.isHidden = false
            driverRiderSwitch.isHidden = false
            SignUpMode = true
            
        }
        
    }
    
}

