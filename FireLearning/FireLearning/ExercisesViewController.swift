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
    
    var user: User?
    var name = ""
    var chosenExercise: Exercise?
    
    //UI
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "createExercise", sender: self)
    }
    @IBOutlet var tableView: UITableView!
    var exercises = [Exercise]()
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        globalUser?.userRef?.child("exercisesOwned").observe(.value, with: { snapshot in
            self.exercises = []
            let tmpExercises = snapshot.value as? [String: AnyObject]
            if(tmpExercises != nil){
                for exercise in tmpExercises!{
                    let tmpExercise = Exercise(_value: exercise.value)
                    self.exercises.append(tmpExercise)
                }
            }
            self.tableView.reloadData()
        })
 
        //Offline-Modus
        //exercises = (globalUser?.user?.exercisesOwned)!
        
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenExercise = exercises[indexPath.row]
        self.performSegue(withIdentifier: "toDetailExercise", sender: nil)
 
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
        }
    }
    
    
}
