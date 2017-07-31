//
//  DetailCreatedQuestionViewController.swift
//  FireLearning
//
//  Created by Admin on 25.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class DetailCreatedQuestionViewController: UIViewController {
    var indexOfQuestion: Int!
    var question: Question!
    var isEditingQuestion = false
    
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
    
    
    //Hilfs-Methoden
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
            (thrdPossTextField.text?.isEmpty)!) {
                self.present(AlertHelper.getSimpleQuestionErrorAlert(), animated: true, completion: nil)
        }
        else{
            question.question = questionTitleTextField.text!
            question.answer = rightAnswerTextField.text!
            question.possibilities[0] = firstPossTextField.text!
            question.possibilities[1] = secPossTextField.text!
            question.possibilities[2] = thrdPossTextField.text!
            
            exerciseQuestions[indexOfQuestion] = question
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadQuestions"), object: nil)
            initView()
            //self.navigationController?.popViewController(animated: true)
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
