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
                    let blocked = User.getBlocked(fromNSDict: value)
                    print("____blocked: \(blocked)")


                    var childrenCount: Int = 0;
                    let exRef = ref.child("users").child(userMail).child("exercisesOwned")
                    exRef.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot!) in
                        print("snapshot.childrenCount: \(snapshot.childrenCount)")
                        childrenCount = Int("\(snapshot.childrenCount)")!
                        if childrenCount > 0 {
                            for index in 0...childrenCount-1 {
                                exRef.child("\(index)").observeSingleEvent(of: .value, with: { snapshot in
                                    
                                    let value = snapshot.value as? NSDictionary
                                    let eid = value?["eid"]
                                    let title = value?["title"]
                                    print("eid: \(eid!)___ title: \(title!)")
                                    
                                    let questions = value?["questions"]
                                    print("questions: \(questions!)")
                                    let dict = value?["questions"] as? NSDictionary
                                    print("questions: \(dict)")
                                    
                                })
                            }
                        }

                    })
                    print("childrenCount: \(childrenCount)")
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
