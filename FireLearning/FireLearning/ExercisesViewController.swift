//
//  ExercisesViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

import UIKit

class ExercisesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var noExercises = false
    var chosenExercise: Exercise?
    var exercises = [Exercise]()
    
    //View-Verbindungen
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "createExercise", sender: self)
    }
    @IBOutlet var tableView: UITableView!
    
    @IBAction func switchToPendingExercisesBtn(_ sender: Any) {
        performSegue(withIdentifier: "toPendingExercises", sender: self)
    
    }
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
                
        globalUser?.userRef?.child("exercisesOwned").observe(.value, with: { snapshot in
            print("observe on ExercisesOwned for User triggered")
            self.exercises = []
            let tmpExercises = snapshot.value as? [String: AnyObject]
            if(tmpExercises != nil){
                self.noExercises = false
                for exercise in tmpExercises!{
                    let tmpExercise = Exercise(anyObject: exercise.value)
                    self.exercises.append(tmpExercise)
                }
            }
            else{
                self.noExercises = true
                let tmpExercise = Exercise(eid: 1, title: "Keine eigenen Aufgaben", questions: [])
                self.exercises.append(tmpExercise)
            }
            self.tableView.reloadData()
        })
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailExercise"){
            let detailViewController = segue.destination as? DetailExerciseViewController
            detailViewController?.exercise = chosenExercise
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //table methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        let text = exercises[indexPath.row].title
        cell.textLabel?.text = text
        if(noExercises == true){
            cell.textLabel?.textColor = UIColor.lightGray
        }
        else{
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(noExercises == false){
            chosenExercise = exercises[indexPath.row]
            self.performSegue(withIdentifier: "toDetailExercise", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(noExercises == false){
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete && noExercises == false) {
            let exerciseKey = "eid\(exercises[indexPath.row].eid)"
            exercises.remove(at: indexPath.row)
            globalUser?.userRef?.child("exercisesOwned").child(exerciseKey).removeValue()
        }
    }
    
    
}
