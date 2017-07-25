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
            print(user?.email)
            
            
            if(user != nil){
                
                let userMail = Helpers.convertEmail(email: (user?.email)!)
                globalUser = GlobalUser(_email: userMail)
                //globalUser.createChangeListener(_email: userMail)
                //globalUser.test(_email: userMail)
                
                DispatchQueue.main.async(){
                    
                    self.performSegue(withIdentifier: "login", sender: self)
                    
                }
            }
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        //let mail = mailOutlet.text!
        let mail = "leo@swag.com"
        //let password = passwordOutlet.text!
        let password = "swag12"
        
        loginHit = true;
        Auth.auth().signIn(withEmail: mail,
                               password: password)
        //Offline Modus:
        //globalUser = GlobalUser()
        //globalUser?.createStaticUserForOfflineLogin()
        
        //self.performSegue(withIdentifier: "login", sender: self)
    }
    
    @IBAction func getAccountButton(_ sender: Any) {
        performSegue(withIdentifier: "getAccount", sender: self)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

