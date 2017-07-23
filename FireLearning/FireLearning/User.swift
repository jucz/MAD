

import Foundation

struct User {
      
    let email: String
    let firstname: String
    let lastname: String
    var exercisesOwned = [Int:Exercise]()
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
         exercisesOwned: [Int:Exercise], blocked: [String], roomsAsTeacher: [Int],
         roomsAsStudent: [Int]) {
        
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.exercisesOwned = exercisesOwned
        self.blocked = blocked
        self.roomsAsTeacher = roomsAsTeacher
        self.roomsAsStudent = roomsAsStudent
    }
    
    //Others
    public func createUserInDB() {
        let email: String = Helpers.convertEmail(email: self.email)
        Helpers.rootRef.child("users").child(email).setValue(self.toAny())
    }
    
    //Convert Object to Any. Result can be saved to Firebase.
    public func toAny() -> Any {
        //TESTDATEN
        let blockedUsers = Helpers.toAny(array: ["olaf@app.de", "peter@app.de"])
        //ENDE TESTDATEN
        var exercisesOwned = [String:Any]()
        for element in self.exercisesOwned {
            exercisesOwned["\(element.key)"] = element.value.toAny()
        }
        let blocked = Helpers.toAny(array: self.blocked)
        let roomsAsTeacher = Helpers.toAny(array: self.roomsAsTeacher)
        let roomsAsStudent = Helpers.toAny(array: self.roomsAsStudent)
        
        return [
            "email": self.email,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "exercisesOwned": exercisesOwned,
            "blocked": blockedUsers, //blocked
            "roomsAsTeacher": roomsAsTeacher,
            "roomsAsStudent": roomsAsStudent
        ]
    }
    
    public static func getBlocked(fromNSDict: NSDictionary?) -> [String] {
        let blockedDict = fromNSDict?["blocked"] as? [String:String]
        var blocked = [String]()
        for element in blockedDict! {
            blocked.append(element.value)
        }
        return blocked
    }
    
    public static func getExercisesOwned(fromNSDict: NSDictionary?) -> [Int:Exercise] {
        let exercisesDict = fromNSDict?["exercisesOwned"] as? [Int:Any]
        print("getExercisesOwned: \(exercisesDict)")
        /*var exercises = [Int:Exercise]()
        if let dict = exercisesDict {
            for (key,value) in exercisesDict! {
                print("\(key)___\(value)")
            }
        }*/
        return [:]
    }
    
    public mutating func addExercise(exercise: Exercise) {
        self.exercisesOwned[exercise.eid] = exercise
    }
    
    
    //Setter
    //Not necessary yet
    
    
    //Getter
    //Not necessary yet
  
}
