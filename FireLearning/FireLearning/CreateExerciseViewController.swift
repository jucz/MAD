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
var noQuestionsInTmpExercise = true

class CreateExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var chosenQuestion: Question?
    var indexOfChosenQuestion: Int?
    
    
    //View-Verbindungen
    @IBOutlet var nameOutlet: UITextField!
    @IBOutlet var questionsTableView: UITableView!
    @IBAction func saveButton(_ sender: Any) {
        let exerciseName = nameOutlet.text!
        if(exerciseName != ""){
//            print(exerciseName)
            
            let exerciseID = 1
            
            //array to Dict
            
            var tmpQuestions = [Question]()
            if(noQuestionsInTmpExercise == false){
                for each in exerciseQuestions{
                    tmpQuestions.append(each)
                }
            }
            else{
                tmpQuestions = []
            }
            
            
            let exercise = Exercise(eid: exerciseID,qids: exerciseQuestionCounter ,title: exerciseName,questions: tmpQuestions)
            globalUser?.addExerciseToDatabaseForGlobalUser(_exercise: exercise)
            self.navigationController?.popViewController(animated: true)
            
        }
        else{
            self.present(AlertHelper.getSimpleExerciseErrorAlert(), animated: true, completion: nil)
        }
    }
    
    @IBAction func createQuestionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createQuestion", sender: self)
    }
    
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTabAnywhere()
        exerciseQuestions = []
        noQuestionsInTmpExercise = true
        let tmpQuestion = Question( question: "bisher keine Frage erstellt", qid: 1, answer: " ", possibilities: [])
        exerciseQuestions.append(tmpQuestion)
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
            let backItem = UIBarButtonItem()
            backItem.title = "Zurück"
            navigationItem.backBarButtonItem = backItem
        }
        if(segue.identifier == "createQuestion"){
            let backItem = UIBarButtonItem()
            backItem.title = "Zurück"
            navigationItem.backBarButtonItem = backItem
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
        
        if(noQuestionsInTmpExercise == true){
            cell.textLabel?.textColor = UIColor.lightGray
        }
        else{
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(noQuestionsInTmpExercise == false){
            chosenQuestion = exerciseQuestions[indexPath.row]
            indexOfChosenQuestion = indexPath.row
            self.performSegue(withIdentifier: "showDetailCreatedQuestion", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(noQuestionsInTmpExercise == false){
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Löschen") { (action, indexPath) in
            if(noQuestionsInTmpExercise == false){
                exerciseQuestions.remove(at: indexPath.row)
                if(exerciseQuestions.count == 0){
                    noQuestionsInTmpExercise = true
                    let tmpQuestion = Question(question: "bisher keine Frage erstellt", qid: 1, answer: " ", possibilities: [])
                    exerciseQuestions.append(tmpQuestion)
                }
                self.questionsTableView.reloadData()
            }
        }
        return [delete]
    }
    
    //NotificationCenter-Methode
    //ReloadData from Child View Controller
    func loadList(){
        questionsTableView.reloadData()
    }
}
