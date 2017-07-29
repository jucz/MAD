//
//  DetailExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 29.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class DetailRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var wasEdited = false
    var editingRoom = false
    var room: Room!
    var chosenQuestion: Question?
    
    //UI
    @IBOutlet var tableView: UITableView!
    var questions = [Question]()
    
    
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for each in exercise.questions{
            questions.append(each)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailQuestion"){
            let detailViewController = segue.destination as? DetailQuestionViewController
            detailViewController?.question = chosenQuestion
            print(detailViewController?.question)
        }
    }
    //Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        let text = questions[indexPath.row].question
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenQuestion = questions[indexPath.row]
        performSegue(withIdentifier: "toDetailQuestion", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
        }
    }
    
    
    
}
