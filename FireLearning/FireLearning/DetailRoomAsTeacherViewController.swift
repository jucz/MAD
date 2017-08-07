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
    var isEditingRoom = false
    var room: Room!
    var chosenExercise: ExerciseExported?
    
//    @IBOutlet var newsTextField: UITextField!
//    @IBOutlet var descTextField: UITextField!
    @IBOutlet var descTextView: UITextView!
    @IBOutlet var newsTextView: UITextView!
    @IBOutlet var roomTitle: UINavigationItem!
    @IBAction func editButton(_ sender: UIButton) {
        self.editRoom()
    }

    @IBOutlet var descLabel: UILabel!
    @IBOutlet var newsLabel: UILabel!
    @IBAction func addExercise(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toAddExercise", sender: nil)
    }
    @IBOutlet var tableViewExercises: UITableView!
    @IBAction func addStudent(_ sender: UIButton) {
        self.presentAddStudentAlert()
    }
    @IBOutlet var tableViewStudents: UITableView!
//    @IBOutlet var roomTitle: UINavigationItem!

//    @IBOutlet var editButtonTitle: UIBarButtonItem!
//    @IBAction func editButton(_ sender: UIButton) {
//        self.editRoom()
//    }
    
//    @IBOutlet var descLabel: UILabel!
//    @IBOutlet var descTextField: UITextField!
//    @IBOutlet var newsLabel: UILabel!
//    @IBOutlet var newsTextField: UITextField!
//    @IBAction func addExercise(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "toAddExercise", sender: nil)
//    }
    
//    @IBAction func addStudent(_ sender: UIButton) {
//        self.presentAddStudentAlert()
//    }
//    @IBOutlet var tableViewExercises: UITableView!
//    @IBOutlet var tableViewStudents: UITableView!
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        roomsRef.child("rid\(self.room.rid)").observe(.value, with: { snapshot in
            self.descTextView.isHidden = true
            self.newsTextView.isHidden = true
            self.room = Room(snapshot: snapshot)
            self.roomTitle.title = self.room.title
            self.descLabel.text = self.room.description
            self.descLabel.sizeToFit()
            self.newsLabel.text = self.room.news
            self.newsLabel.sizeToFit()
            print("\nDetailRoomAsTeacher: observe1")
            self.roomTitle.title = self.room.title
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toExerciseExportedDetail"){
            let detailViewController = segue.destination as? ExportedAsTeacherViewController
            detailViewController?.rid = self.room.rid
            detailViewController?.exported = self.chosenExercise
        }
        if(segue.identifier == "toAddExercise"){
            let detailViewController = segue.destination as? AddExerciseViewController
            detailViewController?.room = self.room
        }
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
            self.performSegue(withIdentifier: "toExerciseExportedDetail", sender: nil)
        }
        
        if tableView == self.tableViewStudents {
//            self.chosenExercise = self.room.students[indexPath.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Löschen") { (action, indexPath) in
            if tableView == self.tableViewExercises {
                
                let exportedExerciseKey = "eid\(self.room.exercises[indexPath.row].exportedExercise.eid)"
                self.room.exercises.remove(at: indexPath.row)
                roomsRef.child("rid\(self.room.rid)").child("exercises").child(exportedExerciseKey).removeValue()
            }
            if tableView == self.tableViewStudents {
                self.room.removeStudent(index: indexPath.row)
            }
        }
        return [delete]
    }
    //Schüler hinzufügen
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
                                                        roomsRef.child("rid\(self.room.rid)").child("students").setValue(self.room.students)
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
    

    //Edit-Methoden
    func editRoom(){
        self.toggleUIforEdit()
        if(isEditingRoom == true){
            self.processEditing()
        }
        self.isEditingRoom = !self.isEditingRoom
    }
    
    func toggleUIforEdit(){
        if !self.isEditingRoom {
            
//            self.editButtonTitle.title = "Speichern"
            self.descTextView.isHidden = false
            self.descTextView.text = self.room.description
            
            var contentSize = self.descTextView.sizeThatFits(self.descTextView.bounds.size)
            var frame = self.descTextView.frame
            frame.size.height = contentSize.height
            self.descTextView.frame = frame
            
            var constraint = NSLayoutConstraint(item: self.descTextView, attribute: .height, relatedBy: .equal, toItem: self.descTextView, attribute: .width, multiplier: descTextView.bounds.height/descTextView.bounds.width, constant: 1)
            self.descTextView.addConstraint(constraint)

            self.newsTextView.isHidden = false
            self.newsTextView.text = self.room.news
            
            contentSize = self.newsTextView.sizeThatFits(self.newsTextView.bounds.size)
            frame = self.newsTextView.frame
            frame.size.height = contentSize.height
            self.newsTextView.frame = frame
            
            constraint = NSLayoutConstraint(item: self.newsTextView, attribute: .height, relatedBy: .equal, toItem: self.newsTextView, attribute: .width, multiplier: newsTextView.bounds.height/newsTextView.bounds.width, constant: 1)
            self.newsTextView.addConstraint(constraint)
            
        } else {
            
            self.descTextView.isHidden = true
            self.newsTextView.isHidden = true
        }
    }
    
    func processEditing(){
        self.room.description = descTextView.text!
        self.room.news = newsTextView.text!
        roomsRef.child("rid\(self.room.rid)").updateChildValues([
            "description": descTextView.text!,
            "news": newsTextView.text!
            ])
    }
    
    
    
    
    
    
}
