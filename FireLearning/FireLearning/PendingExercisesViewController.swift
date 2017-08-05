//
//  pendingExercisesViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseDatabase

//struct RoomExercise {
//    var rid: Int
//    var exercise: ExerciseExported
//    
//    init(rid: Int, exercise: ExerciseExported) {
//        self.rid = rid
//        self.exercise = exercise
//    }
//}

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
        self.pendingExercises = [:]
        
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { (snapshot) in
            print("\nFIRE OBSERVE PENDING EXERCISES!!!\n")
            //tableData reset:
            self.pendingExercises = [:]
            
            let tmpRoomIDs = snapshot.value as? [Int]
            
            if(tmpRoomIDs != nil){
                self.noPendingExercises = false
                var recentStudentRoomIDs = [Int:Int]()
                for each in tmpRoomIDs!{
                    recentStudentRoomIDs[each] = each
                }
                
                
                //neue Observer registireren
                print("\(recentStudentRoomIDs.count)")
                var counter = 0
                
                var freeCounters = [Int]()
                for eachRoomID in recentStudentRoomIDs {
                        /*single
                        Database.database().reference().child("rooms").child("rid\(eachRoomID.key)").child("exercises").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let tmpData = snapshot.value as? [String : AnyObject] {
                                
                                for each in tmpData{
                                    let tmpExportedExercise = ExerciseExported(anyObject: each.value)
                                    let notExpired = tmpExportedExercise.getEndAsDate()! > Date()
                                    let notDone = tmpExportedExercise.statistics.done[(globalUser?.userMail)!] == nil
                                    if notExpired && notDone {
                                        self.pendingExercises[counter] = RoomExercise(rid: eachRoomID.key, exercise: tmpExportedExercise)
                                        counter = counter + 1
                                    }
                                }
                            }
                            
                            
                            self.pendingExercisesTable.reloadData()
                            
                        })
                     */
                    Database.database().reference().child("rooms").child("rid\(eachRoomID.key)").child("exercises").observe(.value, with: { (snapshot) in
                        if let tmpData = snapshot.value as? [String : AnyObject] {
                            //delete old room-exercises from data-array
                            for each in self.pendingExercises{
                                freeCounters.append(each.key)
                                if(each.value.rid == eachRoomID.key){
                                    self.pendingExercises.removeValue(forKey: each.key)
                                }
                            }
                            print(self.pendingExercises)
                            
                            //add recent room-exercises to data-array
                            for each in tmpData{
                                let tmpExportedExercise = ExerciseExported(anyObject: each.value)
                                let endDate = tmpExportedExercise.getEndAsDate()
                                var notExpired = false
                                if endDate != nil && endDate! > Date() {
                                    notExpired = true
                                }
                                let notDone = tmpExportedExercise.statistics.done[(globalUser?.userMail)!] == nil
                                //print("\(tmpExportedExercise):\nNOT EXPIRED: \(notExpired)\nNOT DONE: \(notDone)")
                                if notExpired && notDone {
                                    if(freeCounters.count > 0){
                                        self.pendingExercises[freeCounters[0]] = RoomExercise(rid: eachRoomID.key, exercise: tmpExportedExercise)
                                        freeCounters.remove(at: 0)
                                    }
                                    else{
                                        self.pendingExercises[counter] = RoomExercise(rid: eachRoomID.key, exercise: tmpExportedExercise)
                                        counter = counter + 1
                                    }
                                    print(self.pendingExercises)
                                }
                            }
                        }
                        
                        
                        self.pendingExercisesTable.reloadData()
                        
                    })
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
        var endDate = pendingExercises[indexPath.row]?.exercise.getEndAsDate()
        
        let daysLeft = getDays(_from: Date(), _to: endDate!)
        print(daysLeft)
        
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

    
    //auslagerung spaeter:
    
    func getDays(_from: Date, _to: Date) -> Int{
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: _from, to: _to)
        return components.day!
    
    }
}
