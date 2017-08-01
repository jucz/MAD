//
//  pendingExercisesViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PendingExercisesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var noPendingExercises = false
    var pendingExercises = [Exercise]()
    
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
            //tableData reset:
            self.pendingExercises = []
            
            
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
                            
                            let tmpData = snapshot.value as? [String : AnyObject]
                            
                            for each in tmpData!{
                                let tmpExportedExercise = ExerciseExported(anyObject: each.value)
                                tmpExportedExercises.append(tmpExportedExercise)
                                self.pendingExercises.append(tmpExportedExercise.exportedExercise)
                            }
                            
                            
                            self.pendingExercisesTable.reloadData()
                            
                        })
                
                    }
                }
                
                //alte Observer deregistrieren
                
                self.loggedRoomIDs = recentStudentRoomIDs
            }
            else{
                self.pendingExercises = []
                self.noPendingExercises = true
                self.loggedRoomIDs = [:]
                
                let tmpExercise = Exercise(eid: 1, qids:0, title: "Keine ausstehenden Aufgaben", questions: [])
                self.pendingExercises.append(tmpExercise)
            }
            
        })
        
        
        
        //---
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:false);
        
        pendingExercisesTable.reloadData()
        pendingExercisesTable.dataSource = self
        pendingExercisesTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        let text = pendingExercises[indexPath.row].title
        
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
