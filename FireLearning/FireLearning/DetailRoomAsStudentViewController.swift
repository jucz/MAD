//
//  DetailExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 05.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetailRoomAsStudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var wasEdited = false
    var editingRoom = false
    var room: Room!
    var chosenExercise: ExerciseExported?
    
    
    @IBOutlet var roomTitle: UINavigationItem!
    @IBOutlet var tableViewExercises: UITableView!
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.roomTitle.title = self.room.title
        
        roomsRef.child("rid\(self.room.rid)").observe(.value, with: { snapshot in
            self.room = Room(snapshot: snapshot)
            print("\nDetailRoomAsStudent: observe1")
            //self.roomTitle.title = self.room.title
            self.tableViewExercises.reloadData()
            self.tableViewExercises.allowsMultipleSelectionDuringEditing = false
            self.tableViewExercises.dataSource = self
            self.tableViewExercises.delegate = self
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startTestFromRooms"){
            let questionsInTestViewController = segue.destination as? QuestionsInTestViewController
            //questionsInTestViewController?.questions = []
            questionsInTest = []
            let recentExercise = self.chosenExercise
            
            for each in (self.chosenExercise?.exportedExercise.questions)!{
                //question template convert to real question
                let realQuestion = QuestionInTest(_question: each)
                //questionsInTestViewController?.questions.append(realQuestion)
                questionsInTest.append(realQuestion)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewExercises {
            return self.room.exercises.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        if tableView == self.tableViewExercises {
            let text = self.room.exercises[indexPath.row].exportedExercise.title
            cell.textLabel?.text = text
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableViewExercises {
            self.chosenExercise = self.room.exercises[indexPath.row]
            self.performSegue(withIdentifier: "startTestFromRooms", sender: nil)
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
                roomsRef.child("rid\(self.room.rid)").child("exercises").child(exportedExerciseKey).removeValue()
            }
        }
    }
    
    
}
