//
//  QuestionInTestViewController.swift
//  FireLearning
//
//  Created by Admin on 03.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class QuestionInTestViewController: UIViewController {

    var questionInTest: QuestionInTest!
    var indexOfCurrentQuestion: Int!
    
    //View-Verbindungen
    
    @IBOutlet var questionTitleLabel: UILabel!
    @IBOutlet var firstPossOutlet: UIButton!
    @IBOutlet var secPossOutlet: UIButton!
    @IBOutlet var thrdPossOutlet: UIButton!
    @IBOutlet var fthPossOutlet: UIButton!
    
    @IBAction func firstPossButton(_ sender: Any) {
        saveUserChoice(_userChoice: 0)
    }
    
    @IBAction func secPossButton(_ sender: Any) {
        saveUserChoice(_userChoice: 1)
    }
    
    @IBAction func thrdPossButton(_ sender: Any) {
        saveUserChoice(_userChoice: 2)
    }
    
    @IBAction func fthPossButton(_ sender: Any) {
        saveUserChoice(_userChoice: 3)
    }
    
    
    @IBAction func doneWithQuestionButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(self.questionInTest.userChoice)
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Help-Methoden
    
    func initUI(){
        self.questionTitleLabel.text = self.questionInTest.question
        self.firstPossOutlet.setTitle(self.questionInTest.possibilities[0], for:  .normal)
        self.secPossOutlet.setTitle(self.questionInTest.possibilities[1], for:  .normal)
        self.thrdPossOutlet.setTitle(self.questionInTest.possibilities[2], for:  .normal)
        self.fthPossOutlet.setTitle(self.questionInTest.possibilities[3], for:  .normal)
        
        toggleBorderForUserChoice(_userChoice: self.questionInTest.userChoice)
    }
    
    func saveUserChoice(_userChoice: Int){
        questionInTest.userChoice = _userChoice
        questionsInTest[indexOfCurrentQuestion] = questionInTest
        
        toggleBorderForUserChoice(_userChoice: _userChoice)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "realoadQuestionsInTest"), object: nil)
        
    }
    
    func toggleBorderForUserChoice(_userChoice: Int){
        if(_userChoice == -1){
            return
        }
        else if(_userChoice == 0){
            resetBorderOfButton(_buttonOutlet: secPossOutlet)
            resetBorderOfButton(_buttonOutlet: thrdPossOutlet)
            resetBorderOfButton(_buttonOutlet: fthPossOutlet)
            showChosenButton(_buttonOutlet: firstPossOutlet)
        }
        else if(_userChoice == 1){
            resetBorderOfButton(_buttonOutlet: firstPossOutlet)
            resetBorderOfButton(_buttonOutlet: thrdPossOutlet)
            resetBorderOfButton(_buttonOutlet: fthPossOutlet)
            showChosenButton(_buttonOutlet: secPossOutlet)
            
        }
        else if(_userChoice == 2){
            resetBorderOfButton(_buttonOutlet: firstPossOutlet)
            resetBorderOfButton(_buttonOutlet: secPossOutlet)
            resetBorderOfButton(_buttonOutlet: fthPossOutlet)
            showChosenButton(_buttonOutlet: thrdPossOutlet)
            
        }
        else{
            resetBorderOfButton(_buttonOutlet: firstPossOutlet)
            resetBorderOfButton(_buttonOutlet: secPossOutlet)
            resetBorderOfButton(_buttonOutlet: thrdPossOutlet)
            showChosenButton(_buttonOutlet: fthPossOutlet)
        }
    }
    func showChosenButton(_buttonOutlet: UIButton){
        _buttonOutlet.layer.borderWidth = 3;
        _buttonOutlet.layer.borderColor = UIColor(rgb: UsedColors.getColorAttention()).cgColor
        
    }
    
    func resetBorderOfButton(_buttonOutlet: UIButton){
        _buttonOutlet.layer.borderWidth = 0
        _buttonOutlet.layer.borderColor = UIColor.white.cgColor
    }
}
