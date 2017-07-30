//
//  DetailExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 29.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetailRoomAsTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var wasEdited = false
    var editingRoom = false
    var room: Room!
    var chosenExercise: ExerciseExported?
    
    //var exercises = [ExerciseExported]()
    
    @IBOutlet var roomTitle: UINavigationItem!
    
    @IBAction func addStudent(_ sender: UIButton) {
        self.presentAddStudentAlert()
    }
    @IBOutlet var tableViewExercises: UITableView!
    @IBOutlet var tableViewStudents: UITableView!
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalRooms?.roomsRef.child("rid\(self.room.rid)").observe(.value, with: { snapshot in
            self.room = Room(snapshot: snapshot)
            print("\nDetailRoomAsTeacher: observe1")
            //self.roomTitle.title = self.room.title
            self.tableViewExercises.reloadData()
            self.tableViewStudents.reloadData()
            self.tableViewExercises.allowsMultipleSelectionDuringEditing = false
            self.tableViewStudents.allowsMultipleSelectionDuringEditing = false
            self.tableViewExercises.dataSource = self
            self.tableViewStudents.dataSource = self
            self.tableViewExercises.delegate = self
            self.tableViewStudents.delegate = self
        })


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewExercises {
            return self.room.exercises.count
        }
        if tableView == self.tableViewStudents {
            return self.room.students.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        if tableView == self.tableViewExercises {
            let text = self.room.exercises[indexPath.row].exportedExercise.title
            cell.textLabel?.text = text
        }
        if tableView == self.tableViewStudents {
            let text = self.room.students[indexPath.row]
            cell.textLabel?.text = text
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableViewExercises {
            self.chosenExercise = self.room.exercises[indexPath.row]
            //self.performSegue(withIdentifier: "toDetailExportedExercise", sender: nil)
        }
        
        if tableView == self.tableViewStudents {
            //self.chosenExercise = self.room.students[indexPath.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if tableView == self.tableViewExercises {
                
                let exportedExerciseKey = "eid\(self.room.exercises[indexPath.row].exportedExercise.eid)"
                self.room.exercises.remove(at: indexPath.row)
                globalRooms?.roomsRef.child("rid\(self.room.rid)").child("exercises").child(exportedExerciseKey).removeValue()
                //self.tableViewExercises.reloadData()
            }
            
            if tableView == self.tableViewStudents {
                
                self.removeStudent(index: indexPath.row)
            }
            
        }
    }
    
    func presentAddStudentAlert(){
        let alert = UIAlertController(title: "Nutzer zum Raum hinzufügen", message:
            "E-Mail des Nutzers eingeben", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Hinzufügen",
                                       style: .default) { _ in
                                        guard let textField = alert.textFields?.first,
                                            let user = textField.text else {
                                                return
                                        }
                                        if(user != ""){
                                            let userEmail = Helpers.convertEmail(email: user)
                                            
                                            Database.database().reference().child("users").observeSingleEvent(of: .value, with: {snapshot in
                                                let value = snapshot.value as? [String: AnyObject]
                                                for each in value!{
                                                    if(userEmail == each.key){
                                                        print("gefunden")
                                                        self.room.students.append(user)
                                                        let userRef = Database.database().reference().child("users").child(userEmail)
                                                        userRef.child("roomsAsStudent").observeSingleEvent(of: .value, with: {snapshot in
                                                            var roomsAsStudent = [Int]()
                                                            if let students = snapshot.value as? [Int] {
                                                                roomsAsStudent = students
                                                            }
                                                            roomsAsStudent.append(self.room.rid)
                                                            userRef.child("roomsAsStudent").setValue(roomsAsStudent)
                                                            
                                                        })
                                                        globalRooms?.roomsRef.child("rid\(self.room.rid)").child("students").setValue(self.room.students)
                                                        return
                                                    }
                                                }
                                                
                                                let alertController = UIAlertController(title: "Fehler", message:
                                                    "Kein Nutzer mit dieser Email gefunden!", preferredStyle: UIAlertControllerStyle.alert)
                                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                                                
                                                self.present(alertController, animated: true, completion: nil)
                                            })
                                        }
        }
        let cancelAction = UIAlertAction(title: "Abbrechen",
                                         style: .default)
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeStudent(index: Int) {
        let userEmail = Helpers.convertEmail(email: self.room.students[index])
        self.room.students.remove(at: index)
        globalRooms?.roomsRef.child("rid\(self.room.rid)").child("students").setValue(self.room.students)
        let userRef = Database.database().reference().child("users").child(userEmail).child("roomsAsStudent")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            print("\n\(snapshot)\n")
            var roomsAsStudent = snapshot.value as? [Int]
            if roomsAsStudent != nil {
                var index = 0
                for r in roomsAsStudent! {
                    if r == self.room.rid {
                        roomsAsStudent!.remove(at: index)
                        userRef.setValue(roomsAsStudent)
                        return
                    }
                    index += 1
                }
            }
            
        })
    }
    
    
    
    
    
}
