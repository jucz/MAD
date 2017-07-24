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
                    print("NSDictionary: \(value!)")
                    
                    let blocked = User.getBlocked(fromNSDict: value)
                    print("____blocked: \(blocked)")
                    let roomsAsTeacher = User.getRoomsAsTeacher(fromNSDict: value)
                    print("____asTeacher: \(roomsAsTeacher)")
                    let roomsAsStudent = User.getRoomsAsStudent(fromNSDict: value)
                    print("____asStudent: \(roomsAsStudent)")
                    let exercisesOwned = User.getExercisesOwned(snapshot: snapshot)
                    print("____exercisesOwned: \(exercisesOwned)")
                    self.user = User(email: email, firstname: firstname, lastname: lastname,
                                     exercisesOwned: exercisesOwned, blocked: blocked,
                                     roomsAsTeacher: roomsAsTeacher, roomsAsStudent: roomsAsStudent)
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
