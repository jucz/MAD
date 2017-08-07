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
//    @IBOutlet var roomTitle: UINavigationItem!
//    @IBOutlet var tableViewExercises: UITableView!
    @IBOutlet var newsLabel: UILabel!
    
    @IBOutlet var tableViewExercises: UITableView!
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.roomTitle.title = self.room.title
//        self.descLabel.text = room.description
//        self.newsLabel.text = room.news
//        self.descLabel.sizeToFit()
//        self.newsLabel.sizeToFit()
        
        roomsRef.child("rid\(self.room.rid)").observe(.value, with: { snapshot in
            self.room = Room(snapshot: snapshot)
            print("\nDetailRoomAsStudent: observe1")
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
            //questionsInTestViewController?.questions = []
            questionsInTest = []
//            let recentExercise = self.chosenExercise
            
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
            recentExercise = RoomExercise(rid: self.room.rid, exercise: self.chosenExercise!)
            if self.chosenExercise?.alreadyAnswered(email: (globalUser?.userMail)!) == false {
                self.performSegue(withIdentifier: "startTestFromRooms", sender: nil)
            } else {
                self.present(AlertHelper.getAlreadyAnsweredErrorAlert(), animated: true, completion: nil)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    
}
