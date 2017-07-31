//
//  ViewController.swift
//  FireLearning
//
//  Created by Admin on 15.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


var globalUser: GlobalUser?
var globalRooms: GlobalRooms?

class ViewController: UIViewController {

    @IBOutlet var mailOutlet: UITextField!
    @IBOutlet var passwordOutlet: UITextField!
    var loginHit = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error while signing out!")
        }
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("StateFired")
            print("\nMAIL: \(user?.email)\n")
            
            
            if(user != nil){
                
                let userMail = Helpers.convertEmail(email: (user?.email)!)
                /*ACHTUNG, BITTE SO LASSEN, DAMIT FUNKTIONEN SYNCHRON AUFGERUFEN WERDEN!!
                 ANSONSTEN WÄRE GLOBAL USER IM KONSTRUKTOR VON GLOBAL ROOMS == nil*/
                globalUser = GlobalUser(_email: userMail)
                print("\nglobalRooms: \(globalRooms = GlobalRooms(globalUser: GlobalUser(_email: userMail)))\n")
                DispatchQueue.main.async(){
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {

        //let mail = mailOutlet.text!
        let mail = "leo@swag.com"
        //let mail = "j@app.de"
        
        //let password = passwordOutlet.text!
        let password = "swag12"
        //let password = "j@app.de"
        
        ///JULIAN TESTDATEN
        /*
        var userObj = User(email: "j@app.de",
                        firstname: "Julian",
                        lastname: "Czech")
        var room = Room(title: "10L2", email: "j@app.de")
        room.description = "Latein Blatt 1"
        room.news = "leer"
        room.admin = "j@app.de"
        
        let question = Question(question: "Welche Inselgruppe hat Darwin entdeckt?", answer: "Galapagos", possibilities: ["Seychellen", "Osterinseln", "Falklandinseln"])
        
        var exercise = Exercise(title: "Evolution")
        exercise.addQuestion(question: question)
        userObj.addExercise(exercise: exercise)
        userObj.blocked.append("leo@app.de")
        userObj.blocked.append("purschke@app.de")
        userObj.roomsAsTeacher.append(room.rid)
        userObj.roomsAsStudent.append(room.rid)
        room.addStudent(email: "j@app.de")
        room.addStudent(email: "leo@swag.com")
        room.addExercise(exercise: exercise, start: Date(), end: Date())
        
        userObj.createUserInDB()
        room.createRoomInDB()
 */
        ///ENDE JULIAN

        
        loginHit = true;
        Auth.auth().signIn(withEmail: mail,
                               password: password)
    }
    
    @IBAction func getAccountButton(_ sender: Any) {
        performSegue(withIdentifier: "getAccount", sender: self)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

