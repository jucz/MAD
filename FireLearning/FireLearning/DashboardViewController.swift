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

class DashboardViewController: UIViewController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func retrieveUserFromFIR(withEmail: String) {
        let ref = Database.database().reference()
        ref.child("users").child(withEmail).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            let lastname = value?["lastname"] as? String ?? ""
            let firstname = value?["firstname"] as? String ?? ""
    
            ///JULIAN
            print("NSDictionary: \(value!)")
    
            let blocked = User.getBlocked(snapshot: snapshot)
            let roomsAsTeacher = User.getRoomsAsTeacher(snapshot: snapshot)
            let roomsAsStudent = User.getRoomsAsStudent(snapshot: snapshot)
            let exercisesOwned = User.getExercisesOwned(snapshot: snapshot)
            
            //self.user = User(email: "\(email)2", firstname: firstname, lastname: lastname,
             //                exercisesOwned: exercisesOwned, blocked: blocked,
            //                 roomsAsTeacher: roomsAsTeacher, roomsAsStudent: roomsAsStudent)
            
            (self.user)?.createUserInDB()
            
            print("___User: \(self.user)____")
            
            /*print("____blocked: \(blocked)")
            print("____asTeacher: \(roomsAsTeacher)")
            print("____asStudent: \(roomsAsStudent)")
            print("____exercisesOwned: \(exercisesOwned)")*/
            ///ENDE JULIAN
        })
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
