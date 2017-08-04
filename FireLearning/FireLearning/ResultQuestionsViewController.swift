//
//  ResultQuestionsViewController.swift
//  FireLearning
//
//  Created by Admin on 04.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class ResultQuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var questions: [QuestionInTest]!
    
    var chosenQuestion: QuestionInTest?
    
    //View-Verbindungen
    
    @IBOutlet var questionsTableView: UITableView!
    
    @IBAction func backToOverviewButton(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionsTableView.dataSource = self
        self.questionsTableView.delegate = self
        self.questionsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailResult"){
            let detailResultQuestionsViewController = segue.destination as? DetailResultQuestionsViewController
            detailResultQuestionsViewController?.question = chosenQuestion
        }
    }
    
    //Table-Methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsInTest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        
        let text = questions[indexPath.row].question!
        cell.textLabel?.text = text
        cell.textLabel?.textColor = UIColor.black
        
        if let cellLabel = cell.viewWithTag(100) as? UILabel{
            cellLabel.textColor = UIColor.black
            cellLabel.font.withSize(9)
            
            if(questions[indexPath.row].userChoice == questions[indexPath.row].answer){
                cellLabel.backgroundColor = UIColor(rgb: 0x66FF66)
                cellLabel.text = "richtig"
            }
            else{
                cellLabel.backgroundColor = UIColor(rgb: 0xFF6666)
                cellLabel.text = "falsch"
            }
            
            
            cellLabel.textAlignment = .center
            cellLabel.layer.masksToBounds = true
            cellLabel.layer.cornerRadius = 10
            
        }
        else{
            let cgrect = CGRect(x: 210, y: 8, width: 100, height: 30)
            var cellLabel = UILabel(frame: cgrect)
            cellLabel.tag = 100
            cellLabel.textColor = UIColor.black
            cellLabel.font.withSize(9)
            
            if(questions[indexPath.row].userChoice == questions[indexPath.row].answer){
                cellLabel.backgroundColor = UIColor(rgb: 0x66FF66)
                cellLabel.text = "richtig"
            }
            else{
                cellLabel.backgroundColor = UIColor(rgb: 0xFF6666)
                cellLabel.text = "falsch"
            }
            
            
            cellLabel.textAlignment = .center
            cellLabel.layer.masksToBounds = true
            cellLabel.layer.cornerRadius = 10
            
            cell.contentView.addSubview(cellLabel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        if let cellLabel = cell.viewWithTag(100) as? UILabel{
            if(questions[indexPath.row].userChoice == questions[indexPath.row].answer){
                cellLabel.backgroundColor = UIColor(rgb: 0x66FF66)
                cellLabel.text = "richtig"
            }
            else{
                cellLabel.backgroundColor = UIColor(rgb: 0xFF6666)
                cellLabel.text = "falsch"
            }
        }
        self.chosenQuestion = questions[indexPath.row]
        self.performSegue(withIdentifier: "detailResult", sender: self)
        
    }
    

    
}
