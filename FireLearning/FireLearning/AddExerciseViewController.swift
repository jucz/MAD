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
    var editingExercise = false
    var chosenExercise: Exercise?
    
    //UI
    @IBOutlet var tableView: UITableView!
    let exercises = [Exercise]()
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "toDetailQuestion"){
//            let detailViewController = segue.destination as? DetailQuestionViewController
//            detailViewController?.question = chosenQuestion
//            detailViewController?.eidForExercise = exercise.eid
//        }
//    }
    
    //Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        let text = self.exercises[indexPath.row].title
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenExercise = self.exercises[indexPath.row]
        //todo: exercise hinzufügen
        self.navigationController?.popViewController(animated: true)
        //performSegue(withIdentifier: "toDetailQuestion", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
//    
    
    
}
