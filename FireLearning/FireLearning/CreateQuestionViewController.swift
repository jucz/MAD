//
//  CreateQuestionViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class CreateQuestionViewController: UIViewController {
    //View-Verbindungen
    @IBOutlet var questionText: UITextField!
    @IBOutlet var rightAnswerText: UITextField!
    @IBOutlet var firstPossText: UITextField!
    @IBOutlet var secPossText: UITextField!
    @IBOutlet var thrdPossText: UITextField!
    
    @IBOutlet var saveBtn: UIButton!
    @IBAction func saveButton(_ sender: Any) {
        saveQuestion()
    }
    
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        Style.roundCorners(button: self.saveBtn)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //Methoden:
    func saveQuestion(){
        if( (questionText.text?.isEmpty)! ||
            (rightAnswerText.text?.isEmpty)! ||
            (firstPossText.text?.isEmpty)! ||
            (secPossText.text?.isEmpty)! ||
            (thrdPossText.text?.isEmpty)!){
                self.present(AlertHelper.getSimpleQuestionErrorAlert(), animated: true, completion: nil)
        }
        else{
            var possibilities = [String]()
            possibilities.append(firstPossText.text!)
            possibilities.append(secPossText.text!)
            possibilities.append(thrdPossText.text!)
            let question = Question(question: questionText.text!, qid: exerciseQuestionCounter, answer: rightAnswerText.text!, possibilities: possibilities)
            if(noQuestionsInTmpExercise == true){
                exerciseQuestions.remove(at: 0)
                noQuestionsInTmpExercise = false
            }
            exerciseQuestions.append(question)
            exerciseQuestionCounter = exerciseQuestionCounter + 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadQuestions"), object: nil)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
