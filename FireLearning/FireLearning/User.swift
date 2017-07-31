

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase


struct User {
    
    let email: String
    let firstname: String
    let lastname: String
    var exercisesOwned = [Exercise]()
    var blocked = [String]()
    var roomsAsTeacher = [Int]() //speichert rids der Raeume
    var roomsAsStudent = [Int]() //speichert rids der Raeume

    //Constructors
    //Wrid benutzt um User zu generieren, der in Firebase importiert werden soll
    init(email: String, firstname: String, lastname: String) {
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
    }
    
    //Wird benutzt, um User aus aus Firebase bezogenen Daten zu generieren
    init(email: String, firstname: String, lastname: String,
         exercisesOwned: [Exercise], blocked: [String], roomsAsTeacher: [Int],
         roomsAsStudent: [Int]) {
        
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.exercisesOwned = exercisesOwned
        self.blocked = blocked
        self.roomsAsTeacher = roomsAsTeacher
        self.roomsAsStudent = roomsAsStudent
    }
    
    ///JULIAN
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? NSDictionary
        self.email = value?["email"] as? String ?? ""
        self.lastname = value?["lastname"] as? String ?? ""
        self.firstname = value?["firstname"] as? String ?? ""
        
        //print("NSDictionary: \(value!)")
        
        self.blocked = User.getBlocked(snapshot: snapshot)
        self.roomsAsTeacher = User.getRoomsAsTeacher(snapshot: snapshot)
        self.roomsAsStudent = User.getRoomsAsStudent(snapshot: snapshot)
        self.exercisesOwned = User.getExercisesOwned(snapshot: snapshot)
        print("___User: \(self)____")
    }
    ///ENDE JULIAN
  
    ///Others
    public func createUserInDB() {
        let email: String = Helpers.convertEmail(email: self.email)
        Helpers.rootRef.child("users").child(email).setValue(self.toAny())
    }
    
    //Convert Object to Any. Result can be saved to Firebase.
    public func toAny() -> Any {
        var exercisesOwned = [String:Any]()
        for element in self.exercisesOwned {
            exercisesOwned["eid\(element.eid)"] = element.toAny()
        }
    
        return [
            "email": self.email,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "exercisesOwned": exercisesOwned,
            "blocked": self.blocked,
            "roomsAsTeacher": self.roomsAsTeacher,
            "roomsAsStudent": self.roomsAsStudent
        ]
    }
    
    public mutating func addExercise(exercise: Exercise) {
        self.exercisesOwned.append(exercise)
    }
    
    public func checkIfBlocked(email: String) -> Bool {
        for mail in self.blocked {
            if mail == email {
                return true
            }
        }
        return false
    }

    public func checkIfAdmin(rid: Int) -> Bool {
        for room in self.roomsAsTeacher {
            if room == rid {
                return true
            }
        }
        return false
    }
    
    
    
    
    
    
    
    ///Setter
    //Not necessary yet
    
    
    
    
    
    
    
    ///Getter
    public static func getEmail(snapshot: DataSnapshot) -> String {
        let values = snapshot.value as? NSDictionary
        return values?["email"] as? String ?? ""
    }
    
    public static func getFirstname(snapshot: DataSnapshot) -> String {
        let values = snapshot.value as? NSDictionary
        return values?["firstname"] as? String ?? ""
    }
    
    public static func getLastname(snapshot: DataSnapshot) -> String {
        let values = snapshot.value as? NSDictionary
        return values?["lastname"] as? String ?? ""
    }
    
    public static func getBlocked(snapshot: DataSnapshot) -> [String] {
        let values = snapshot.value as? NSDictionary
        if let blockedDict = values?["blocked"] as? [String] {
            return blockedDict
        } else {
            return [String]()
        }
    }
    
    public static func getRoomsAsStudent(snapshot: DataSnapshot) -> [Int] {
        let values = snapshot.value as? NSDictionary
        if let asStudent = values?["roomsAsStudent"] as? [Int] {
            return asStudent
        } else {
            return [Int]()
        }
    }
    
    public static func getRoomsAsTeacher(snapshot: DataSnapshot) -> [Int] {
        let values = snapshot.value as? NSDictionary
        if let asTeacher = values?["roomsAsTeacher"] as? [Int] {
            return asTeacher
        } else {
            return [Int]()
        }
    }
    
    
    public static func getExercisesOwned(snapshot: DataSnapshot) -> [Exercise] {
        let values = snapshot.value as? [String:AnyObject]
        let allExercises = values?["exercisesOwned"] as? [String:AnyObject]
        var exercises = [Exercise]()
        if allExercises != nil {
            //Exercises holen
            for e in allExercises! {
                //Questions holen
                exercises.append(Exercise(anyObject: e.value))
                //Ende Questions holen
            }
            //Ende Exercises holen
        }
        return exercises
    }
  
}


