//
//  CreateExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit


var questions = [Question]()

class CreateExerciseViewController: UIViewController, UITableViewDataSource {

    @IBAction func createQuestionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createQuestion", sender: self)
    }
    @IBOutlet var questionsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTableView.dataSource = self
        
    }

    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToAllExercises", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //questions-Methoden
    

    //table methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell")!
        
        let question = questions[indexPath.row].question
        
        cell.textLabel?.text = question
        
        return cell
    }

}
