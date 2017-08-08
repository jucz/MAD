//
//  DetailExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 21.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class DetailExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var noQuestions = false
    var wasEdited = false
    var editingExercise = false
    var exercise: Exercise!
    var chosenQuestion: Question?
    var questions = [Question]()
    
    //UI
    @IBOutlet var tableView: UITableView!
    @IBAction func addQuestionButton(_ sender: Any) {
        performSegue(withIdentifier: "toCreateQuestion", sender: self)
    }
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        globalUser?.userRef?.child("exercisesOwned").child("eid\(exercise.eid)").child("questions").observe(.value, with: { (snapshot) in
//            print("observe on questions for User exercises triggered")
            self.questions = []
            let tmpQuestions = snapshot.value as? [String: AnyObject]
            if(tmpQuestions != nil){
                self.noQuestions = false
                for question in tmpQuestions!{
                    let tmpQuestion = Question(anyObject: question.value)
                    self.questions.append(tmpQuestion)
                }
            }
            else{
                self.noQuestions = true
                
                let tmpQuestion = Question(question: "Keine Fragen vorhanden", qid: 1, answer: " ", possibilities: [])
                self.questions.append(tmpQuestion)
            }
            self.tableView.reloadData()
        })
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailQuestion"){
            let detailViewController = segue.destination as? DetailQuestionViewController
            detailViewController?.question = chosenQuestion
            detailViewController?.eidForExercise = exercise.eid
        }
        else if(segue.identifier == "toCreateQuestion"){
            let createQuestionViewController = segue.destination as? CreateQuestionForExistingExerciseViewController
            createQuestionViewController?.exercise = exercise
        }
    }
    //Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)        
        let text = questions[indexPath.row].question
        cell.textLabel?.text = text
        if(noQuestions == true){
            cell.textLabel?.textColor = UIColor.lightGray
        }
        else{
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(noQuestions == false){
            chosenQuestion = questions[indexPath.row]
            performSegue(withIdentifier: "toDetailQuestion", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(noQuestions == false){
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Löschen") { (action, indexPath) in
            if (self.noQuestions == false) {
                let questionKey = "qid\(self.questions[indexPath.row].qid)"
                self.questions.remove(at: indexPath.row)
                globalUser?.userRef?
                    .child("exercisesOwned")
                    .child("eid\(self.exercise.eid)")
                    .child("questions")
                    .child(questionKey)
                    .removeValue()
            }
        }
        return [delete]
    }
    

}
