//
//  DetailResultQuestionsViewController.swift
//  FireLearning
//
//  Created by Admin on 04.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class DetailResultQuestionsViewController: UIViewController {

    var question: QuestionInTest!
    
    //View-Verbindungen
    
    @IBOutlet var questionTitleText: UILabel!
    @IBOutlet var firstPossText: UILabel!
    @IBOutlet var secPossText: UILabel!
    @IBOutlet var thrdPossText: UILabel!
    @IBOutlet var fthPossText: UILabel!
    
    @IBOutlet var firstRightAnswerBorder: UIView!
    @IBOutlet var secRightAnswerBorder: UIView!
    @IBOutlet var thrdRightAnswerBorder: UIView!
    @IBOutlet var fthRightAnswerBorder: UIView!
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Helper-Methoden
    func initUI(){
        self.questionTitleText.text = self.question.question
        self.firstPossText.text = self.question.possibilities[0]
        self.secPossText.text = self.question.possibilities[1]
        self.thrdPossText.text = self.question.possibilities[2]
        self.fthPossText.text = self.question.possibilities[3]
        
        firstRightAnswerBorder.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
        secRightAnswerBorder.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
        thrdRightAnswerBorder.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
        fthRightAnswerBorder.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
        
        toggleBorderForUserChoice(_userChoice: self.question.userChoice)
        showRightAnswerBorder(_rightAnswer: self.question.answer)
    }
    
    
    func showRightAnswerBorder(_rightAnswer: Int){
        if(self.question.answer == 0){
            firstRightAnswerBorder.isHidden = false
        }
        else if(self.question.answer == 1){
            secRightAnswerBorder.isHidden = false
        }
        else if(self.question.answer == 2){
            thrdRightAnswerBorder.isHidden = false
        }
        else{
            fthRightAnswerBorder.isHidden = false
        }
    }
    func toggleBorderForUserChoice(_userChoice: Int){
        if(_userChoice == -1){
            return
        }
        else if(_userChoice == 0){
            resetBorderOfButton(_uiLabel: secPossText)
            resetBorderOfButton(_uiLabel: thrdPossText)
            resetBorderOfButton(_uiLabel: fthPossText)
            showChosenButton(_uiLabel: firstPossText)
        }
        else if(_userChoice == 1){
            resetBorderOfButton(_uiLabel: firstPossText)
            resetBorderOfButton(_uiLabel: thrdPossText)
            resetBorderOfButton(_uiLabel: fthPossText)
            showChosenButton(_uiLabel: secPossText)
            
        }
        else if(_userChoice == 2){
            resetBorderOfButton(_uiLabel: firstPossText)
            resetBorderOfButton(_uiLabel: secPossText)
            resetBorderOfButton(_uiLabel: fthPossText)
            showChosenButton(_uiLabel: thrdPossText)
            
        }
        else{
            resetBorderOfButton(_uiLabel: firstPossText)
            resetBorderOfButton(_uiLabel: secPossText)
            resetBorderOfButton(_uiLabel: thrdPossText)
            showChosenButton(_uiLabel: fthPossText)
        }
    }
    func showChosenButton(_uiLabel: UILabel){
        _uiLabel.layer.borderWidth = 3;
        _uiLabel.layer.borderColor = UIColor(rgb: UsedColors.getColorAttention()).cgColor
        
    }
    
    func resetBorderOfButton(_uiLabel: UILabel){
        _uiLabel.layer.borderWidth = 0
        _uiLabel.layer.borderColor = UIColor.white.cgColor
    }
}
