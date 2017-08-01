//
//  pendingExercisesViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class PendingExercisesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var noPendingExercises = false
    var pendingExercises = [Exercise]()
    
    var loggedRoomIDs = [Int:Int]()
    
    //View-Verbindungen
    @IBAction func switchToCreatedExercisesBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBOutlet var pendingExercisesTable: UITableView!
    
    //System-Methoden
    override func viewDidLoad() {
        
        var roomIDsAsStudent = [Int:Int]()
        
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { (snapshot) in
            var tmpRoomIDs = snapshot.value as? [Int]
            if(tmpRoomIDs != nil){
                //momentane IDs holen
                for eachRoomID in tmpRoomIDs!{
                    roomIDsAsStudent[eachRoomID] = eachRoomID
                }
                //neue Observer registireren
                for eachRoomID in roomIDsAsStudent{
                   // var loggedValueForId
                }
                
                //alte Observer deregistrieren
                
                
                self.loggedRoomIDs = roomIDsAsStudent
            }
            else{
                self.pendingExercises = []
                self.noPendingExercises = true
                self.loggedRoomIDs = [:]
                
                let tmpExercise = Exercise(eid: 1, title: "Keine ausstehenden Aufgaben", questions: [])
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

}
