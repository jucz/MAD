//
//  DetailQuestionViewController.swift
//  FireLearning
//
//  Created by Admin on 21.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class DetailQuestionViewController: UIViewController {
    
    @IBOutlet var questionTitleText: UILabel!
    @IBOutlet var rightAnswerText: UILabel!
    @IBOutlet var firstPossText: UILabel!
    @IBOutlet var secPossText: UILabel!
    @IBOutlet var thrdPossText: UILabel!
    
    
    var question: Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initView(){
        questionTitleText.text = question.question
        rightAnswerText.text = question.answer
        firstPossText.text = question.possibilities[0]
        secPossText.text = question.possibilities[1]
        thrdPossText.text = question.possibilities[2]
    }
}
