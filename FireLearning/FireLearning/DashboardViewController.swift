//
//  DashboardViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

var globalUser: User!

class DashboardViewController: UIViewController {
    
    var user: User?
    var children: Int = 0
    var blocked = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userMail = String()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            
            if(user != nil){
                
                userMail = Helpers.convertEmail(email: (user?.email)!)
                
                //user aus datenbank in globalUser laden
                let ref = Database.database().reference()
                ref.child("users").child(userMail).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let email = value?["email"] as? String ?? ""
                    let lastname = value?["lastname"] as? String ?? ""
                    let firstname = value?["firstname"] as? String ?? ""
                    
                    ///JULIAN
                    let value2 = snapshot.value as? [String:AnyObject]
                    print("NSDictionary: \(value!)")
                    print("[String:AnyObject]: \(value2!)")
                    
                    self.blocked = User.getBlocked(fromNSDict: value)
                    print("____blocked: \(self.blocked)")

                    User.getExercisesOwned(snapshot: snapshot)
                    /*let exRef = ref.child("users").child(userMail).child("exercisesOwned")
                    exRef.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot!) in
                        self.children = Int("\(snapshot.childrenCount)")!
                        print("children: \(self.children)")
                    })
                    if childrenCount > 0 {
                        for index in 0...childrenCount-1 {
                            
                        }
                    }*/
                    ///ENDE JULIAN
                    
                    let user = User(email: email, firstname: firstname, lastname: lastname)
                    print(user.lastname)
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
        
        
        
        //

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
