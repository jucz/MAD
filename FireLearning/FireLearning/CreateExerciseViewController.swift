//
//  CreateExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

var exerciseQuestionCounter = 0
var exerciseQuestions = [Int:Question]()
var exerciseName = String()

class CreateExerciseViewController: UIViewController, UITableViewDataSource {
    
    //View Verbindungen
    @IBOutlet var nameOutlet: UITextField!
    
    @IBAction func createQuestionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createQuestion", sender: self)
    }
    @IBOutlet var questionsTableView: UITableView!
    
    @IBAction func saveButton(_ sender: Any) {
        exerciseName = nameOutlet.text!
        let exerciseID = 1
        let exercise = Exercise(eid: exerciseID,title: exerciseName,questions: exerciseQuestions)
        print(exercise.title)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToAllExercises", sender: self)
    }
    
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTableView.dataSource = self
        nameOutlet.text = exerciseName
        print(exerciseName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //questions-Methoden
    

    //table methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell")!
        
        let question = exerciseQuestions[indexPath.row]?.question
        
        cell.textLabel?.text = question
        
        return cell
    }

}
