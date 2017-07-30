//
//  DetailExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 29.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class DetailRoomAsTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var wasEdited = false
    var editingRoom = false
    var room: Room!
    var chosenExercise: ExerciseExported?
    
    //var exercises = [ExerciseExported]()
    
    @IBOutlet var roomTitle: UINavigationItem!
    
    @IBOutlet var tableViewExercises: UITableView!
    @IBOutlet var tableViewStudents: UITableView!
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.roomTitle.title = self.room.title
        
        print("\nviewDidLoad: DetailRoomAsTeacher \(self.room.title)")
        
        for e in self.room.exercises {
            //self.exercises.append(e)
            print("\nviewDidLoad: addExercise \(e.exportedExercise.title)")
        }
        
        tableViewExercises.reloadData()
        tableViewStudents.reloadData()
        tableViewExercises.allowsMultipleSelectionDuringEditing = false
        tableViewStudents.allowsMultipleSelectionDuringEditing = false
        tableViewExercises.dataSource = self
        tableViewStudents.dataSource = self
        tableViewExercises.delegate = self
        tableViewStudents.delegate = self
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
        if tableView == self.tableViewStudents {
            self.chosenExercise = self.room.exercises[indexPath.row]
            //self.performSegue(withIdentifier: "toDetailExportedExercise", sender: nil)
        }
        
        if tableView == self.tableViewStudents {
            //self.chosenExercise = self.room.exercises[indexPath.row]
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
                self.tableViewExercises.reloadData()
            }
            if tableView == self.tableViewStudents {
                print("\nROW: \(indexPath.row)")
                self.room.students.remove(at: indexPath.row)
                self.tableViewStudents.reloadData()
                globalRooms?.roomsRef.child("rid\(self.room.rid)").child("students").setValue(self.room.students)
            }
            
        }
    }
    
    
    
    
    
}
