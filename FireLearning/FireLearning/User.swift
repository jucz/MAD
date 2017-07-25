

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

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
        //let blockedUsers = Helpers.toAny(array: ["olaf@app.de", "peter@app.de"])
        //let asTeacher = Helpers.toAny(array: [4,5,6])
        //let asStudent = Helpers.toAny(array: [4,5,6])
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
            "blocked": blocked,
            "roomsAsTeacher": roomsAsTeacher,
            "roomsAsStudent": roomsAsStudent
        ]
    }
    
    /*public func toAnyObject() -> AnyObject {
        //TESTDATEN
        let blockedUsers = Helpers.toAnyObject(array: ["olaf@app.de", "peter@app.de"])
        //ENDE TESTDATEN
        var exercisesOwned = [String:AnyObject]()
        for element in self.exercisesOwned {
            exercisesOwned["\(element.key)"] = element.value.toAnyObject()
        }
        let blocked = Helpers.toAnyObject(array: self.blocked)
        let roomsAsTeacher = Helpers.toAnyObject(array: self.roomsAsTeacher)
        let roomsAsStudent = Helpers.toAnyObject(array: self.roomsAsStudent)
        
        return {
            var email = self.email;
            var firstname = self.firstname;
            var lastname = self.lastname;
            var exercisesOwned = exercisesOwned;
            var blocked = blockedUsers; //blocked
            var roomsAsTeacher = roomsAsTeacher;
            var roomsAsStudent = roomsAsStudent;
        } as AnyObject
    }*/
    
    public static func getEmail(snapshot: DataSnapshot) -> String {
        let fromNSDict = snapshot.value as? NSDictionary
        return fromNSDict?["email"] as? String ?? ""
    }
    
    public static func getFirstname(snapshot: DataSnapshot) -> String {
        let fromNSDict = snapshot.value as? NSDictionary
        return fromNSDict?["firstname"] as? String ?? ""
    }
    
    public static func getLastname(snapshot: DataSnapshot) -> String {
        let fromNSDict = snapshot.value as? NSDictionary
        return fromNSDict?["lastname"] as? String ?? ""
    }
    
    public static func getBlocked(snapshot: DataSnapshot) -> [String] {
        let fromNSDict = snapshot.value as? NSDictionary
        let blockedDict = fromNSDict?["blocked"] as? [String:String]
        var blocked = [String]()
        if blockedDict != nil {
            for element in blockedDict! {
                blocked.append(element.value)
            }
        }
        return blocked
    }
    
    public static func getRoomsAsStudent(snapshot: DataSnapshot) -> [Int] {
        let fromNSDict = snapshot.value as? NSDictionary
        let asStudentDict = fromNSDict?["roomsAsStudent"] as? [String:String]
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
        let fromNSDict = snapshot.value as? NSDictionary
        let asTeacherDict = fromNSDict?["roomsAsTeacher"] as? [String:String]
        var asTeacher = [Int]()
        if asTeacherDict != nil {
            for element in asTeacherDict! {
                print("element.value: \(element.value)")
                asTeacher.append(Int(element.value)!)
            }
        }
        return asTeacher
    }
    
    
    public static func getExercisesOwned(snapshot: DataSnapshot) -> [Int:Exercise] {
        let values = snapshot.value as? [String:AnyObject]
        let exTmp = values?["exercisesOwned"] as? [[String:AnyObject]]
        var exercises = [Int:Exercise]()
        if exTmp != nil {
            //Questions holen
            for exerciseElement in exTmp! {
                let eid = (exerciseElement["eid"])! as! Int
                let title = (exerciseElement["title"])! as! String
                
                //Loop durch alle Fragen:
                print("Questions: \((exerciseElement["questions"])!)")
                let allQuestions = (exerciseElement["questions"])! as! [AnyObject]
                var questions = [Int:Question]()
                for questionElement in allQuestions {
                    let qid = questionElement["qid"] as! Int
                    let question = questionElement["question"] as! String
                    let answerIndex = questionElement["answerIndex"] as! Int
                    let answersMapped = questionElement["answers"] as? [String:String]
                    
                    var answers = [String]()
                    if answersMapped != nil {
                        for answer in answersMapped! {
                            answers.append(answer.value)
                        }
                    }
                    questions[qid] = Question(qid: qid, question: question, answerIndex: answerIndex, answers: answers)
                }
                exercises[eid] = Exercise(eid: eid, title: title, questions: questions)
                //Ende Questions holen
            }
            print("Exercises: \(exercises)")
        }
        return exercises
    }
    
    public mutating func addExercise(exercise: Exercise) {
        self.exercisesOwned[exercise.eid] = exercise
    }
    
    
    //Setter
    //Not necessary yet
    
    
    //Getter
    //Not necessary yet
  
}
