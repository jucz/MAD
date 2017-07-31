//
//  CreateQuestionForExistingExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateQuestionForExistingExerciseViewController: UIViewController {

    var exercise: Exercise!
    //View-Verbindungen
    
    @IBOutlet var questionTitleText: UITextField!
    @IBOutlet var rightAnswerText: UITextField!
    @IBOutlet var firstPossText: UITextField!
    @IBOutlet var secPossText: UITextField!
    @IBOutlet var thrdPossText: UITextField!
    
    @IBAction func saveButton(_ sender: Any) {
        saveQuestion()
    }
    
    //Methoden:
    func saveQuestion(){
        if( (questionTitleText.text?.isEmpty)! ||
            (rightAnswerText.text?.isEmpty)! ||
            (firstPossText.text?.isEmpty)! ||
            (secPossText.text?.isEmpty)! ||
            (thrdPossText.text?.isEmpty)!){
                self.present(AlertHelper.getSimpleQuestionErrorAlert(), animated: true, completion: nil)
        }
        else{
            var qidRef = Database.database().reference().child("qids")
            qidRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let qid = snapshot.value as! Int
                var possibilities = [String]()
                possibilities.append(self.firstPossText.text!)
                possibilities.append(self.secPossText.text!)
                possibilities.append(self.thrdPossText.text!)
                let question = Question(question: self.questionTitleText.text!, answer: self.rightAnswerText.text!, possibilities: possibilities)
                
                
                globalUser?.userRef?.child("exercisesOwned").child("eid\(self.exercise.eid)").child("questions").updateChildValues([
                    "qid\(question.qid)" : question.toAny()
                ])
                
                self.navigationController?.popViewController(animated: true)
                qidRef.setValue(qid+1)
            })
        }
    }
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
