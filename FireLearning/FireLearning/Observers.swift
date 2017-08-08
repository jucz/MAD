//
//  Observers.swift
//  FireLearning
//
//  Created by Studium on 08.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Foundation

class Observers {

    //Pending Exercises
    var noPendingExercises = false
    var pendingExercises = [Int:RoomExercise]()
    var oberversPendingExercises = [UInt]()
    var tableViewsPendingExercises = [UITableView]()
        
    func initObserversPendingExercises() {
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { (snapshot) in
            self.pendingExercises = [:]
            for handle in self.oberversPendingExercises {
                Database.database().reference().removeObserver(withHandle: handle)
            }
            
            let tmpRoomIDs = snapshot.value as? [Int]
            
            if(tmpRoomIDs != nil){
                self.noPendingExercises = false
                var recentStudentRoomIDs = [Int:Int]()
                for each in tmpRoomIDs!{
                    recentStudentRoomIDs[each] = each
                }
                
                for eachRoomID in recentStudentRoomIDs {
                    self.oberversPendingExercises.append(
                        Database.database().reference().child("rooms").child("rid\(eachRoomID.key)").child("exercises").observe(.value, with: { (snapshot) in
                            if let exerciseList = snapshot.value as? [String : AnyObject] {
                                print("\nOBSERVE: (rid\(eachRoomID.key))")
                                
                                //entferne Platzhalter und mache Platz für echte Exercises
                                if self.pendingExercises.count == 1 && self.pendingExercises[0] != nil && self.pendingExercises[0]?.rid == -1 {
                                    self.pendingExercises = [:]
                                }
                                
                                //alle Fragebögen eines Raumes löschen und übrige sortieren, um sie neu einbauen zu können
                                self.deleteExercisesOfRoom(rid: eachRoomID.key)
                                self.reorderExercisesByIndex()
                                //add recent room-exercises to data-array
                                for each in exerciseList {
                                    let exportedExerciseTmp = ExerciseExported(anyObject: each.value)
                                    let endDate = exportedExerciseTmp.getEndAsDate()
                                    var notExpired = false
                                    if endDate != nil && endDate! > Date() {
                                        notExpired = true
                                    }
                                    let notEmpty = exportedExerciseTmp.exportedExercise.questions.count > 0
                                    let notDone = exportedExerciseTmp.statistics.done[(globalUser?.userMail)!] == nil
                                    
                                    if notExpired && notDone && notEmpty {
                                        self.pendingExercises[self.pendingExercises.count] = RoomExercise(rid: eachRoomID.key, exercise: exportedExerciseTmp)
                                        //                                       print(self.pendingExercises)
                                    }
                                }
                                self.handleNoExercises()
                                
                            } else {
                                print("\nOBSERVE: (rid\(eachRoomID.key): NO EXERCISES)")
                                //alle Fragebögen eines Raumes löschen und übrige sortieren, um sie neu einbauen zu können
                                self.deleteExercisesOfRoom(rid: eachRoomID.key)
                                self.reorderExercisesByIndex()
                                self.handleNoExercises()
                            }
                        })
                    )
                }
                self.handleNoExercises()
            }
            self.handleNoExercises()
        })
    }
    
    func handleNoExercises() {
        if self.pendingExercises.count == 0 {
            self.noPendingExercises = true
            let exercise = Exercise(title: "Kein Fragebogen vorhanden", qids: 0)
            let exported = ExerciseExported(exercise: exercise, start: "", end: "")
            self.pendingExercises[0] = RoomExercise(rid: -1, exercise: exported)
        } else if self.pendingExercises.count == 1 && self.pendingExercises[0] != nil && self.pendingExercises[0]?.rid == -1 {
            
        } else {
            self.noPendingExercises = false
        }
        for tV in self.tableViewsPendingExercises {
            tV.reloadData()
        }
    }
    
    //alle Exercises eines Rooms löschen
    func deleteExercisesOfRoom(rid: Int) {
        if self.pendingExercises.count > 0 {
            for i in 0...self.pendingExercises.count-1 {
                if self.pendingExercises[i]?.rid == rid {
                    self.pendingExercises.removeValue(forKey: i)
                }
            }
        }
    }
    
    //neu mit Indizes sortieren
    func reorderExercisesByIndex() {
        let arrayed = self.pendingExercises.reversed()
        self.pendingExercises = [:]
        if arrayed.count > 0 {
            for i in 0...arrayed.count-1 {
                self.pendingExercises[i] = arrayed[i].value
            }
        }
    }
    
}

