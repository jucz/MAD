//
//  DetailExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var wasEdited = false
    var room: Room!
    var editingExercise = false
    var chosenExercise: Exercise?
    var datepicker: UIDatePicker!
    
    //@IBAction func
    
    //UI
    @IBOutlet var tableView: UITableView!
    var exercises = [Exercise]()
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datepicker = UIDatePicker(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 250))
        
        globalUser?.userRef?.observe(.value, with: { snapshot in
            self.exercises = User.getExercisesOwned(snapshot: snapshot)
            self.removeIfAlreadyExported()
            print("\nAddExerciseViewController: viewDidLoad \(self.exercises)\n")
            
            self.tableView.reloadData()
            self.tableView.allowsMultipleSelectionDuringEditing = false
            self.tableView.dataSource = self
            self.tableView.delegate = self
        })
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDatePicker"){
            let backItem = UIBarButtonItem()
            backItem.title = "Zurück"
            navigationItem.backBarButtonItem = backItem
            let detailViewController = segue.destination as? DatePickerViewController
            detailViewController?.exercise = self.chosenExercise
            detailViewController?.room = self.room
        }
    }
    
    //Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        let text = self.exercises[indexPath.row].title
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenExercise = self.exercises[indexPath.row]
        //globalRooms?.roomsRef.child("rid\(self.room.rid)").child("exercises")
        self.datepicker.datePickerMode = UIDatePickerMode.dateAndTime
        self.datepicker.minimumDate = Date()
        //self.view.addSubview(datepicker)
        //todo: Start- und Enddatum hinzufügen
        //ende todo
        self.room.addExercise(exercise: chosenExercise!, start: "", end: "")
        roomsRef.child("rid\(self.room.rid)").child("exercises").setValue(self.room.exercisesToAny())
        //self.room.createRoomInDB()
        self.performSegue(withIdentifier: "toDatePicker", sender: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func removeIfAlreadyExported() {
        var index1 = 0
        for _ in self.room.exercises {
            let title = self.room.exercises[index1].exportedExercise.title
            var index2 = 0
            for _ in self.exercises {
                if title == self.exercises[index2].title {
                    self.exercises.remove(at: index2)
                    index2 = 0
                    break
                } else {
                    index2 += 1
                }
            }
            index1 += 1
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let questionKey = "qid\(questions[indexPath.row].qid)"
//            questions.remove(at: indexPath.row)
//            globalUser?.userRef?
//                .child("exercisesOwned")
//                .child("eid\(exercise.eid)")
//                .child("questions")
//                .child(questionKey)
//                .removeValue()
//            
//        }
//    }
    
    
}
