//
//  CreateExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

var exerciseQuestionCounter = 0
var exerciseQuestions = [Question]()

class CreateExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //chosenQuestion
    var chosenQuestion: Question?
    var indexOfChosenQuestion: Int?
    
    //View-Verbindungen
    @IBOutlet var nameOutlet: UITextField!
    @IBOutlet var questionsTableView: UITableView!
    @IBAction func saveButton(_ sender: Any) {
        let exerciseName = nameOutlet.text!
        if(exerciseName != ""){
            print(exerciseName)
            
            let exerciseID = 1
            
            //array to Dict
            var tmpQuestions = [Question]()
            
            for each in exerciseQuestions{
                tmpQuestions.append(each)
            }
            
            let exercise = Exercise(eid: exerciseID,title: exerciseName,questions: tmpQuestions)
            globalUser?.addExerciseToDatabaseForGlobalUser(_exercise: exercise)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailCreatedQuestion"){
            let detailCreatedQuestionViewController = segue.destination as? DetailCreatedQuestionViewController
            detailCreatedQuestionViewController?.question = chosenQuestion
            detailCreatedQuestionViewController?.indexOfQuestion = indexOfChosenQuestion
        }
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
        let question = exerciseQuestions[indexPath.row]
        cell.textLabel?.text = question.question
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenQuestion = exerciseQuestions[indexPath.row]
        indexOfChosenQuestion = indexPath.row
        self.performSegue(withIdentifier: "showDetailCreatedQuestion", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            exerciseQuestions.remove(at: indexPath.row)
            questionsTableView.reloadData()
        }
    }
    //ReloadData from Child View Controller
    func loadList(){
        questionsTableView.reloadData()
    }
}
