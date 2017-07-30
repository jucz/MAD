//
//  DetailExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 29.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class DetailRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var wasEdited = false
    var editingRoom = false
    var room: Room!
    var chosenExercise: ExerciseExported?
    
    var exercises = [ExerciseExported]()
    
    //UI
    @IBOutlet var tableView: UITableView!
    
    
    
    
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for e in self.room.exercises {
            self.exercises.append(e)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailExerciseExported"){
            let detailViewController = segue.destination as? DetailExerciseExportedViewController
            detailViewController?.exercise = self.chosenExercise?.exportedExercise
            print(detailViewController?.exercise ?? "")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        let text = self.exercises[indexPath.row].exportedExercise.title
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenExercise = self.exercises[indexPath.row]
        performSegue(withIdentifier: "toDetailQuestion", sender: self)
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
