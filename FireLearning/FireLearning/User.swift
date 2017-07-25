

import Foundation
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
         exercisesOwned: [String], roomsAsTeacher: [Int],
         roomsAsStudent: [Int]) {
        
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
    }
    init(snapshot: DataSnapshot) {
        //key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.email = snapshotValue["email"] as! String
        self.firstname = snapshotValue["firstname"] as! String
        self.lastname = snapshotValue["lastname"] as! String
        
        //exercisesOwned = (snapshotValue["exercisesOwned"] as? [Int:String])
        //Aufgaben holen
        if let exercisesDict = snapshotValue["exercisesOwned"] as? [String:AnyObject]{
            for each in exercisesDict{
                
                let title = each.value["title"] as! String
                let eid = each.value["eid"] as! Int
                
                
                let questions = each.value["questions"] as? [String:AnyObject]
                print(type(of: questions))
                for q in questions!{
                    let question = q.value["question"] as! String
                    print(question)
                }
                
                var tmp = Exercise(title: title)
                print(tmp.title)
                //self.exercisesOwned.append(each.value as! Exercise)
            }
            
        }else{
            print("exercisesDict is null")
        }
        //Blocked holen
        if let blockedDict = snapshotValue["blocked"] as? [String:AnyObject]{
            
            for each in blockedDict{
                self.blocked.append(each.value as! String)
            }
            
        }else{
            print("blockedDict is null")
        }
        //roomsAsTeacher holen
        if let roomsAsTeacherDict = snapshotValue["roomsAsTeacher"] as? [String:AnyObject]{
            
            for each in roomsAsTeacherDict{
                self.roomsAsTeacher.append(each.value as! Int)
            }
            
        }else{
            print("roomsAsTeacherDict is null")
        }
        //roomsAsStudent holen
        if let roomsAsStudentDict = snapshotValue["roomsAsStudent"] as? [String:AnyObject]{
            
            for each in roomsAsStudentDict{
                self.roomsAsStudent.append(each.value as! Int)
            }
            
        }else{
            print("roomsAsStudentDict is null")
        }
    }
    
    //Others
    public func createUserInDB() {
        let email: String = Helpers.convertEmail(email: self.email)
        let ref = Helpers.rootRef.child("users")
        ref.child(email).setValue(self.toAny())
    }
    
    //Convert Object to Any. Result can be saved to Firebase.
    public func toAny() -> Any {
        //TESTDATEN
        let blockedUsers = Helpers.toAny(array: ["olaf@app.de", "peter@app.de"])
        //ENDE TESTDATEN
        let blocked = Helpers.toAny(array: self.blocked)
        let roomsAsTeacher = Helpers.toAny(array: self.roomsAsTeacher)
        let roomsAsStudent = Helpers.toAny(array: self.roomsAsStudent)
        
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
    
    
    //Setter
    //Not necessary yet
    
    
    //Getter
    //Not necessary yet
  
}
