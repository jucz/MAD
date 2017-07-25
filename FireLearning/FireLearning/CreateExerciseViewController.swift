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

class CreateExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //View-Verbindungen
    @IBOutlet var nameOutlet: UITextField!
    
    
    @IBOutlet var questionsTableView: UITableView!
    @IBAction func saveButton(_ sender: Any) {
        let exerciseName = nameOutlet.text!
        if(exerciseName != ""){
            print(exerciseName)
            let exerciseID = 1
            let exercise = Exercise(eid: exerciseID,title: exerciseName,questions: exerciseQuestions)
            //globalUser?.addExerciseToDatabaseForGlobalUser(_exercise: exercise)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func createQuestionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createQuestion", sender: self)
    }
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "reloadQuestions"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Table-Methoden
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
    //ReloadData from Child View Controller
    func loadList(){
        questionsTableView.reloadData()
    }
}
