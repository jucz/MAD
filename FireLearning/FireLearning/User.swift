

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
    //Convert Object to Any. Result can be saved to Firebase.
    public func toAny() -> Any {
        //TESTDATEN
        let blockedUsers = self.toAny(array: ["olaf@app.de", "peter@app.de"])
        //ENDE TESTDATEN
        let blocked = self.toAny(array: self.blocked)
        let roomsAsTeacher = self.toAny(array: self.roomsAsTeacher)
        let roomsAsStudent = self.toAny(array: self.roomsAsStudent)
        
        return [
            "email": self.email,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "exercisesOwned": self.exercisesOwned,
            "blocked": blockedUsers, //blocked
            "roomsAsTeacher": roomsAsTeacher,
            "roomsAsStudent": roomsAsStudent
        ]
    }
    
    //Converts an Array to a directory which can be saved in Firebase as Any
    public func toAny(array: [String]?) -> Any? {
        if array == nil {
            return nil
        }
        var list: [String:String] = [:]
        for element in array! {
            list[User.convertEmail(email: element)] = element
        }
        return list
    }
    
    public func toAny(array: [Int]?) -> Any? {
        if array == nil {
            return nil
        }
        var list: [String:Int] = [:]
        for element in array! {
            list["\(element)"] = element
        }
        return list
    }
    
    //Convert all not allowed characters to alternative substrings
    public static func convertEmail(email: String) -> String {
        return email.replacingOccurrences(of: "@", with: "at").replacingOccurrences(of: ".", with: "dot")
    }
    
    
    //Setter
    //Not necessary yet
    
    
    //Getter
    public func getEmail() -> String {
        return self.email
    }
  
}
