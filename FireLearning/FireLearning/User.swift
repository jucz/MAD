

import Foundation
import FirebaseAuth

struct User {
  
    let email: String
    let firstname: String
    let lastname: String
    var exercisesOwned = [Int:String]()
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
         exercisesOwned: [Int:String], roomsAsTeacher: [Int],
         roomsAsStudent: [Int]) {
        
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
    }
    
    //Others
    public func toAnyObject() -> Any {
        return [
            "email": self.email,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "exercisesOwned": self.exercisesOwned,
            "blocked": self.blocked,
            "roomsAsTeacher": self.roomsAsTeacher,
            "roomsAsStudent": self.roomsAsStudent
        ]
    }
    
    
    //Setter
    //Not necessary yet
    
    
    //Getter
    public func getEmail() -> String {
        return self.email
    }
  
}
