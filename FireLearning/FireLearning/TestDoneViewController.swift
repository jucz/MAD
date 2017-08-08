//
//  TestDoneViewController.swift
//  FireLearning
//
//  Created by Admin on 03.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit



class TestDoneViewController: UIViewController {
    
    var answeredQuestions: [QuestionInTest]!
    var rightPercentage: Double!
    
    //View-Verbindungen
    
    @IBOutlet var backToOverviewBtn: UIButton!
    @IBOutlet var showResultsBtn: UIButton!
    @IBOutlet var percentageText: UILabel!
    
    @IBAction func backToOverviewButton(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func showResults(_ sender: Any) {
        self.performSegue(withIdentifier: "showResults", sender: self)
    }
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        Style.roundCorners(button: self.backToOverviewBtn)
        Style.roundCorners(button: self.showResultsBtn)
        self.navigationItem.setHidesBackButton(true, animated:false);
        percentageText.text = "\(rightPercentage!) % \n richtig beantwortet"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showResults"){
            let resultQuestionsViewController = segue.destination as? ResultQuestionsViewController
            resultQuestionsViewController?.questions = answeredQuestions
        }
    }
}
