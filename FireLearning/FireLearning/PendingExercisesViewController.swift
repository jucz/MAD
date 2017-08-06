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
        
        
        if(noPendingExercises == true){
            cell.textLabel?.textColor = UIColor.lightGray
        }
        else{
            let endDate = pendingExercises[indexPath.row]?.exercise.getEndAsDate()
            
            var daysLeft: Int
            if endDate != nil {
                daysLeft = getDays(_from: Date(), _to: endDate!)
            } else {
                daysLeft = 0
            }
            cell.textLabel?.textColor = UIColor.black
            if let cellLabel = cell.viewWithTag(100) as? UILabel{
                if(daysLeft >= 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
                }
                else if(daysLeft >= 3 && daysLeft < 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorAttention())
                }
                else{
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorDanger())
                }
            }
            else{
                let cgrect = CGRect(x: 210, y: 8, width: 100, height: 30)
                let cellLabel = UILabel(frame: cgrect)
                cellLabel.tag = 100
                cellLabel.textColor = UIColor.black
                cellLabel.font.withSize(9)
                cellLabel.text = "noch \(daysLeft) Tage"
                
                if(daysLeft >= 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
                }
                else if(daysLeft >= 3 && daysLeft < 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorAttention())
                }
                else{
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorDanger())
                }
                cellLabel.textAlignment = .center
                cellLabel.layer.masksToBounds = true
                cellLabel.layer.cornerRadius = 10
                
                cell.contentView.addSubview(cellLabel)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(noPendingExercises == false){
            let endDate = pendingExercises[indexPath.row]?.exercise.getEndAsDate()
            
            var daysLeft: Int
            if endDate != nil {
                daysLeft = getDays(_from: Date(), _to: endDate!)
            } else {
                daysLeft = 0
            }
            
            let cell = tableView.cellForRow(at: indexPath) as UITableViewCell?
            if let cellLabel = cell?.viewWithTag(100) as? UILabel{
                if(daysLeft >= 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
                }
                else if(daysLeft >= 3 && daysLeft < 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorAttention())
                }
                else{
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorDanger())
                }
            }
            self.chosenExercise = self.pendingExercises[indexPath.row]
            self.performSegue(withIdentifier: "startTest", sender: self)
        }
    }
    
    //auslagerung spaeter:
    
    func getDays(_from: Date, _to: Date) -> Int{
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: _from, to: _to)
        return components.day!
    
    }
}
