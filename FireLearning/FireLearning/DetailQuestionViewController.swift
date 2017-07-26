//
//  DetailQuestionViewController.swift
//  FireLearning
//
//  Created by Admin on 21.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class DetailQuestionViewController: UIViewController {
    var isEditingQuestion = false
    var question: Question!
    
    //View-Verbindungen
    @IBOutlet var questionTitleText: UILabel!
    @IBOutlet var rightAnswerText: UILabel!
    @IBOutlet var firstPossText: UILabel!
    @IBOutlet var secPossText: UILabel!
    @IBOutlet var thrdPossText: UILabel!
    
    @IBOutlet var questionTitleTextField: UITextField!
    @IBOutlet var rightAnswerTextField: UITextField!
    @IBOutlet var firstPossTextField: UITextField!
    @IBOutlet var secPossTextField: UITextField!
    @IBOutlet var thrdPossTextField: UITextField!
    
    @IBOutlet var saveEditButton: UIBarButtonItem!
    @IBAction func saveEditButton(_ sender: Any) {
        editQuestion()
    }
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initView(){
        questionTitleText.text = question.question
        rightAnswerText.text = question.answer
        firstPossText.text = question.possibilities[0]
        secPossText.text = question.possibilities[1]
        thrdPossText.text = question.possibilities[2]
        
        questionTitleTextField.text = question.question
        rightAnswerTextField.text = question.answer
        firstPossTextField.text = question.possibilities[0]
        secPossTextField.text = question.possibilities[1]
        thrdPossTextField.text = question.possibilities[2]
    }
    
    
    //Edit-Methoden
    func editQuestion(){
        toggleUIforEdit()
        if(isEditingQuestion == true){
            checkForCorrectEditing()
        }
        isEditingQuestion = !isEditingQuestion
    }
    func checkForCorrectEditing(){
        if( (questionTitleTextField.text?.isEmpty)! ||
            (rightAnswerTextField.text?.isEmpty)! ||
            (firstPossTextField.text?.isEmpty)! ||
            (secPossTextField.text?.isEmpty)! ||
            (thrdPossTextField.text?.isEmpty)!){
            print("nicht alles fuer Frage ausgefuellt!")
        }
        else{
            question.question = questionTitleTextField.text!
            question.answer = rightAnswerTextField.text!
            question.possibilities[0] = firstPossTextField.text!
            question.possibilities[1] = secPossTextField.text!
            question.possibilities[2] = thrdPossTextField.text!
            initView()
            
            //update this question for the exercise chosen in parent controller
            // -> update parent controller data
            //    via a singleEvent observe of that modified exercise
            // 
            //  ---> globalUser.updateQuestionFor(_eid: Int, _question: Question)
            //                 (( func has to be modified to sth like this)
            
        }
    }
    func toggleUIforEdit(){
        if(isEditingQuestion){
            //Bar-Button
            saveEditButton.title = "Ändern"
            
            //show Labels
            questionTitleText.isHidden = false
            rightAnswerText.isHidden = false
            firstPossText.isHidden = false
            secPossText.isHidden = false
            thrdPossText.isHidden = false
            
            
            //hide TextFields
            questionTitleTextField.isHidden = true
            rightAnswerTextField.isHidden = true
            firstPossTextField.isHidden = true
            secPossTextField.isHidden = true
            thrdPossTextField.isHidden = true
        }
        else{
            //Bar-Button
            saveEditButton.title = "Speichern"
            
            //hide Labels
            questionTitleText.isHidden = true
            rightAnswerText.isHidden = true
            firstPossText.isHidden = true
            secPossText.isHidden = true
            thrdPossText.isHidden = true
            
            //show TextFields
            questionTitleTextField.isHidden = false
            rightAnswerTextField.isHidden = false
            firstPossTextField.isHidden = false
            secPossTextField.isHidden = false
            thrdPossTextField.isHidden = false
        }
    }
}