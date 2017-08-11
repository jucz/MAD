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
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var newsLabel: UILabel!
    
    @IBOutlet var tableViewExercises: UITableView!
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTabAnywhere()
        
        roomsRef.child("rid\(self.room.rid)").observe(.value, with: { snapshot in
            self.room = Room(snapshot: snapshot)
            self.tableViewExercises.reloadData()
            self.tableViewExercises.allowsMultipleSelectionDuringEditing = false
            self.tableViewExercises.dataSource = self
            self.tableViewExercises.delegate = self
            self.roomTitle.title = self.room.title
            self.descLabel.text = self.room.description
            self.newsLabel.text = self.room.news
            self.descLabel.sizeToFit()
            self.newsLabel.sizeToFit()
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
            _ = segue.destination as? QuestionsInTestViewController
            questionsInTest = []
            
            for each in (self.chosenExercise?.exportedExercise.questions)!{
                let realQuestion = QuestionInTest(_question: each)
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
            recentExercise = RoomExercise(rid: self.room.rid, exercise: self.chosenExercise!)
            
            if self.chosenExercise?.alreadyAnswered(email: (globalUser?.userMail)!) == true {
                self.present(AlertHelper.getAlreadyAnsweredErrorAlert(), animated: true, completion: nil)
                
            } else if self.chosenExercise?.started() == false {
                self.present(AlertHelper.getExerciseNotStartedYet(start: (self.chosenExercise?.getStart())!), animated: true, completion: nil)
                
            } else if self.chosenExercise?.expired() == true {
                self.present(AlertHelper.getExerciseExpired(end: (self.chosenExercise?.getEnd())!), animated: true, completion: nil)

            } else {
                self.performSegue(withIdentifier: "startTestFromRooms", sender: nil)
            }
        }
    }
    
    
}
