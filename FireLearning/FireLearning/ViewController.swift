//
//  ViewController.swift
//  FireLearning
//
//  Created by Admin on 15.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


var globalUser: GlobalUser?
var globalRooms: GlobalRooms?

class ViewController: UIViewController {

    @IBOutlet var mailOutlet: UITextField!
    @IBOutlet var passwordOutlet: UITextField!
    var loginHit = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error while signing out!")
        }
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("StateFired")
            print("\nMAIL: \(user?.email)\n")
            if(user != nil){
                let userMail = Helpers.convertEmail(email: (user?.email)!)
                /*ACHTUNG, BITTE SO LASSEN, DAMIT FUNKTIONEN SYNCHRON AUFGERUFEN WERDEN!!
                 ANSONSTEN WÄRE GLOBAL USER IM KONSTRUKTOR VON GLOBAL ROOMS == nil*/
                globalUser = GlobalUser(_email: userMail)
                print("\nglobalRooms: \(globalRooms = GlobalRooms(globalUser: GlobalUser(_email: userMail)))\n")
                DispatchQueue.main.async(){
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {

        //let mail = mailOutlet.text!
        //let mail = "leo@swag.com"
        let mail = "j@app.de"
        
        //let password = passwordOutlet.text!
        //let password = "swag12"
        let password = "j@app.de"
        
        loginHit = true;
        Auth.auth().signIn(withEmail: mail,
                               password: password)
    }
    
    @IBAction func getAccountButton(_ sender: Any) {
        performSegue(withIdentifier: "getAccount", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

