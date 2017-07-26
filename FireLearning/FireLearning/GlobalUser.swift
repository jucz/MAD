//
//  GlobalUser.swift
//  FireLearning
//
//  Created by Admin on 21.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//
import UIKit
import Foundation
import FirebaseDatabase

class GlobalUser{
    
    public var user: User?
    public var userRef: DatabaseReference?
    public var userMail: String?
    
    
    init(_email: String){
        userRef = Database.database().reference().child("users").child(_email)
        userMail = _email
        self.retrieveUserFromFIR(withEmail: _email)
    }
    
    init(){
        user = nil
    }
    
    public func updateName(_name: String){
        userRef?.updateChildValues([
            "lastname": _name
        ])
    }
    
    public func addExerciseToDatabaseForGlobalUser(_exercise: Exercise){
        Database.database().reference().child("eids").observeSingleEvent(of: .value, with: { snapshot in
            
            var id = snapshot.value as! Int
            
            var tmpExercise = Exercise(_exercise: _exercise)
            tmpExercise.eid = id
            self.userRef?.child("exercisesOwned").updateChildValues([
                "eid\(tmpExercise.eid)": tmpExercise.toAny()
            ])
            
            Database.database().reference().child("eids").setValue(id+1)
            
        })

    }
    
    public func createStaticUserForOfflineLogin(){
        self.user = User(email: "default@default.com", firstname: "First", lastname: "Last")
        //BlockList
        self.user?.blocked.append("blocked@blocked.de")
        //Aufgaben
        let question = Question(qid: 1, question: "Wie spät?", answer: "19Uhr", possibilities: ["20Uhr","21Uhr","22Uhr"])
        var exercise = Exercise(title: "offline Aufgabe")
        exercise.addQuestion(question: question)
        self.user?.exercisesOwned.append(exercise)
    }
    
 
    public func updateQuestionInExercise(){
        
    }
    public func retrieveUserFromFIR(withEmail: String) {
        userRef?.observeSingleEvent(of: .value, with: { snapshot in
            self.user = User(snapshot: snapshot)
        })
    }
}
