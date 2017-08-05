//
//  pendingExercisesViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct RoomExercise {
    var rid: Int
    var exercise: ExerciseExported
    
    init(rid: Int, exercise: ExerciseExported) {
        self.rid = rid
        self.exercise = exercise
    }
}

class PendingExercisesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var noPendingExercises = false
    //var pendingExercises = [Exercise]()
    ///J
    var pendingExercises = [Int:RoomExercise]() //[index:[rid:ExerciseExported]]
    var chosenExercise: RoomExercise?
    ///
    
    //var chosenExercise: Exercise?
    
    
    
    var loggedRoomIDs = [Int:Int]()
    
    //Observer:
    var handle: UInt = 0
    
    //View-Verbindungen
    @IBAction func switchToCreatedExercisesBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBOutlet var pendingExercisesTable: UITableView!
    
    //System-Methoden
    override func viewDidLoad() {
        
        
        var roomIDsAsStudent = [Int:Int]()
        
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { (snapshot) in
            print("\nFIRE OBSERVE PENDING EXERCISES!!!\n")
            //tableData reset:
            self.pendingExercises = [:]
            
            
            var tmpRoomIDs = snapshot.value as? [Int]
            
            print("\(tmpRoomIDs)")
            if(tmpRoomIDs != nil){
                self.noPendingExercises = false
                var recentStudentRoomIDs = [Int:Int]()
                for each in tmpRoomIDs!{
                    recentStudentRoomIDs[each] = each
                }
                
                
                //neue Observer registireren
                print("\(recentStudentRoomIDs.count)")
                for eachRoomID in recentStudentRoomIDs {
                    let loggedValueForID = self.loggedRoomIDs[eachRoomID.key]
                    if(loggedValueForID != nil){
                        print("nicht nil\(eachRoomID.key)")
                        //Database.database().reference().child("rooms").child("rid\(logged)")
                    }
                    else{
                        print("nil")
                        Database.database().reference().child("rooms").child("rid\(eachRoomID.key)").child("exercises").observeSingleEvent(of: .value, with: { (snapshot) in
                            var tmpExportedExercises = [ExerciseExported]()
                            
                            if let tmpData = snapshot.value as? [String : AnyObject] {
                                var i = 0
                                for each in tmpData{
                                    let tmpExportedExercise = ExerciseExported(anyObject: each.value)
                                    let notExpired = tmpExportedExercise.getEndAsDate()! > Date()
                                    let notDone = tmpExportedExercise.statistics.done[(globalUser?.userMail)!] == nil
                                    if notExpired && notDone {
                                        tmpExportedExercises.append(tmpExportedExercise)
                                        self.pendingExercises[i] = RoomExercise(rid: eachRoomID.key, exercise: tmpExportedExercise)
                                        i += 1
                                    }
                                }
                            }
                            
                            
                            self.pendingExercisesTable.reloadData()
                            
                        })
                
                    }
                }
                
                //alte Observer deregistrieren
                
                self.loggedRoomIDs = recentStudentRoomIDs
            }
            else{
                self.pendingExercises = [:]
                self.noPendingExercises = true
                self.loggedRoomIDs = [:]
                
                let tmpExercise = ExerciseExported(exercise: Exercise(eid: 1, qids:0, title: "Keine ausstehenden Aufgaben", questions: []), start: "", end: "")
                self.pendingExercises[0] = RoomExercise(rid: -1, exercise: tmpExercise)
            }
            
        })
        
        
        
        //---
        
        
//        let tmpQuestion1 = Question(question: "Was ist Pinarello?", qid: 0, answer: "Fahrradmarke", possibilities: ["Automarke", "ital. König", "der neue Lamborghini"])
//        let tmpQuestion2 = Question(question: "Wie oft hat Chris Froome die Tour de France gewonnen?", qid: 0, answer: "4 mal", possibilities: ["3 mal", "nie", "mehr als 6 mal"])
//        let tmpQuestion3 = Question(question: "Wer ist Alberto Contador", qid: 0, answer: "Radfahrer", possibilities: ["Schauspieler", "Musiker", "Arzt"])
//        
//        var tmpQuestions1 = [Question]()
//        
//        
//        tmpQuestions1.append(tmpQuestion1)
//        tmpQuestions1.append(tmpQuestion2)
//        tmpQuestions1.append(tmpQuestion3)
//        var exercise1 = Exercise(eid: 1, qids: 2, title: "Sport", questions: tmpQuestions1)
//        self.pendingExercises.append(exercise1)
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:false);
        
        pendingExercisesTable.reloadData()
        pendingExercisesTable.dataSource = self
        pendingExercisesTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Data transfer to Test View Controller
        if(segue.identifier == "startTest"){
            let questionsInTestViewController = segue.destination as? QuestionsInTestViewController
            //questionsInTestViewController?.questions = []
            questionsInTest = []
            recentExercise = self.chosenExercise
            
            for each in (self.chosenExercise?.exercise.exportedExercise.questions)!{
                //question template convert to real question
                let realQuestion = QuestionInTest(_question: each)
                //questionsInTestViewController?.questions.append(realQuestion)
                questionsInTest.append(realQuestion)
            }
        }
    }
    //Table-Methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingExercises.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingExerciseCell", for: indexPath)
        
        let text = pendingExercises[indexPath.row]?.exercise.exportedExercise.title
        
        cell.textLabel?.text = text
        if(noPendingExercises == true){
            cell.textLabel?.textColor = UIColor.lightGray
        }
        else{
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(noPendingExercises == false){
            self.chosenExercise = self.pendingExercises[indexPath.row]
            self.performSegue(withIdentifier: "startTest", sender: self)
        }
    }
    
    
    /* nicht editierbar als schueler: sosnt wiweder einkommentieren
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(noPendingExercises == false){
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete && noPendingExercises == false) {
            
        }
    }
 */

}
