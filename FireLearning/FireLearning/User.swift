

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
        
        print("NSDictionary: \(value!)")
        
        self.blocked = User.getBlocked(snapshot: snapshot)
        self.roomsAsTeacher = User.getRoomsAsTeacher(snapshot: snapshot)
        self.roomsAsStudent = User.getRoomsAsStudent(snapshot: snapshot)
        self.exercisesOwned = User.getExercisesOwned(snapshot: snapshot)
        
        print("___User: \(self)____")
    }
    ///ENDE JULIAN
    
//    init(snapshot: DataSnapshot) {
//        //key = snapshot.key
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        self.email = snapshotValue["email"] as! String
//        self.firstname = snapshotValue["firstname"] as! String
//        self.lastname = snapshotValue["lastname"] as! String
//        
//        //exercisesOwned = (snapshotValue["exercisesOwned"] as? [Int:String])
//        //Aufgaben holen
//        if let exercisesDict = snapshotValue["exercisesOwned"] as? [String:AnyObject]{
//            for each in exercisesDict{
//                
//                let title = each.value["title"] as! String
//                let eid = each.value["eid"] as! Int
//                
//                
//                let questions = each.value["questions"] as? [String:AnyObject]
//                print(type(of: questions))
//                for q in questions!{
//                    let question = q.value["question"] as! String
//                    print(question)
//                }
//                
//                var tmp = Exercise(title: title)
//                print(tmp.title)
//                //self.exercisesOwned.append(each.value as! Exercise)
//            }
//            
//        }else{
//            print("exercisesDict is null")
//        }
//        //Blocked holen
//        if let blockedDict = snapshotValue["blocked"] as? [String:AnyObject]{
//            
//            for each in blockedDict{
//                self.blocked.append(each.value as! String)
//            }
//            
//        }else{
//            print("blockedDict is null")
//        }
//        //roomsAsTeacher holen
//        if let roomsAsTeacherDict = snapshotValue["roomsAsTeacher"] as? [String:AnyObject]{
//            
//            for each in roomsAsTeacherDict{
//                self.roomsAsTeacher.append(each.value as! Int)
//            }
//            
//        }else{
//            print("roomsAsTeacherDict is null")
//        }
//        //roomsAsStudent holen
//        if let roomsAsStudentDict = snapshotValue["roomsAsStudent"] as? [String:AnyObject]{
//            
//            for each in roomsAsStudentDict{
//                self.roomsAsStudent.append(each.value as! Int)
//            }
//            
//        }else{
//            print("roomsAsStudentDict is null")
//        }
//    }
    
    ///Others
    public func createUserInDB() {
        let email: String = Helpers.convertEmail(email: self.email)
        Helpers.rootRef.child("users").child(email).setValue(self.toAny())
    }
    
    //Convert Object to Any. Result can be saved to Firebase.
    public func toAny() -> Any {
        //TESTDATEN
        //let blockedUsers = Helpers.toAny(array: ["olaf@app.de", "peter@app.de"])
        //let asTeacher = Helpers.toAny(array: [4,5,6])
        //let asStudent = Helpers.toAny(array: [4,5,6])
        //ENDE TESTDATEN
        var exercisesOwned = [String:Any]()
        for element in self.exercisesOwned {
            exercisesOwned["\(element.eid)"] = element.toAny()
        }
        let blocked = Helpers.toAny(array: self.blocked)
        let roomsAsTeacher = Helpers.toAny(array: self.roomsAsTeacher)
        let roomsAsStudent = Helpers.toAny(array: self.roomsAsStudent)
        
        return [
            "email": self.email,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "exercisesOwned": exercisesOwned,
            "blocked": blocked,
            "roomsAsTeacher": roomsAsTeacher,
            "roomsAsStudent": roomsAsStudent
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
        let blockedDict = values?["blocked"] as? [String:String]
        var blocked = [String]()
        if blockedDict != nil {
            for element in blockedDict! {
                blocked.append(element.value)
            }
        }
        return blocked
    }
    
    public static func getRoomsAsStudent(snapshot: DataSnapshot) -> [Int] {
        let values = snapshot.value as? NSDictionary
        let asStudentDict = values?["roomsAsStudent"] as? [String:String]
        var asStudent = [Int]()
        if asStudentDict != nil {
            for element in asStudentDict! {
                print("element.value: \(element.value)")
                asStudent.append(Int(element.value)!)
            }
        }
        return asStudent
    }
    
    public static func getRoomsAsTeacher(snapshot: DataSnapshot) -> [Int] {
        let values = snapshot.value as? NSDictionary
        let asTeacherDict = values?["roomsAsTeacher"] as? [String:String]
        var asTeacher = [Int]()
        if asTeacherDict != nil {
            for element in asTeacherDict! {
                print("element.value: \(element.value)")
                asTeacher.append(Int(element.value)!)
            }
        }
        return asTeacher
    }
    
    
    public static func getExercisesOwned(snapshot: DataSnapshot) -> [Exercise] {
        let values = snapshot.value as? [String:AnyObject]
        let allExercises = values?["exercisesOwned"] as? [AnyObject]
        var exercises = [Exercise]()
        if allExercises != nil {
            //Exercises holen
            for e in allExercises! {
                //Questions holen
                exercises.append(Exercise(anyObject: e))
                //Ende Questions holen
            }
            //Ende Exercises holen
            print("Exercises: \(exercises)")
        }
        return exercises
    }
  
}
