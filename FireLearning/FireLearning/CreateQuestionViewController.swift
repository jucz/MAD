//
//  CreateQuestionViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class CreateQuestionViewController: UIViewController {

    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToCreateExercise", sender: self)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        
        var answers = [String]()
        answers.append(rightAnswerText.text!)
        answers.append(firstPossText.text!)
        answers.append(secPossText.text!)
        answers.append(thrdPossText.text!)
        if( (questionText.text?.isEmpty)! ||
            (rightAnswerText.text?.isEmpty)! ||
            (firstPossText.text?.isEmpty)! ||
            (secPossText.text?.isEmpty)! ||
            (thrdPossText.text?.isEmpty)!){
            print("nicht alles fuer Fragen ausgefuellt!")
        }
        else{
            var question = Question(question: questionText.text!, answerIndex: 0, answers: answers)
            questions.append(question)
            self.performSegue(withIdentifier: "backToCreateExercise", sender: self)
        }
    }
    //Question Outlets
    @IBOutlet var questionText: UITextField!
    
    @IBOutlet var rightAnswerText: UITextField!
    
    @IBOutlet var firstPossText: UITextField!
    @IBOutlet var secPossText: UITextField!
    @IBOutlet var thrdPossText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
