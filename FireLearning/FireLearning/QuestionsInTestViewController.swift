//
//  QuestionsInTestViewController.swift
//  FireLearning
//
//  Created by Admin on 03.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

var recentExercise: RoomExercise?
var questionsInTest = [QuestionInTest]()




extension Double{
    func roundTo(places: Int) -> Double{
        let devisior = pow(10.0, Double(places))
        return (self * devisior).rounded() / devisior
    }
}

class QuestionsInTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var questions: [QuestionInTest]!
    
    var chosenQuestion: QuestionInTest?
    var indexOfChosenQuestion: Int?
    
    //View-Verbindungen
    
    @IBOutlet var questionsTableView: UITableView!
    
    @IBAction func testDoneButton(_ sender: Any) {
        self.performSegue(withIdentifier: "testDone", sender: self)
    }
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(realoadQuestionsInTest), name: NSNotification.Name(rawValue: "realoadQuestionsInTest"), object: nil)
        
        self.questionsTableView.delegate = self
        self.questionsTableView.dataSource = self
        
        self.questionsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "answerQuestion"){
            let questionInTestViewController = segue.destination as? QuestionInTestViewController
            questionInTestViewController?.questionInTest = self.chosenQuestion
            questionInTestViewController?.indexOfCurrentQuestion = self.indexOfChosenQuestion
        }
        else if(segue.identifier == "testDone"){
            let testDoneViewController = segue.destination as? TestDoneViewController
            testDoneViewController?.answeredQuestions = questionsInTest
            
            //calculate avg
            var rightAnswers = 0
            for each in questionsInTest{
                if(each.answer == each.userChoice){
                    rightAnswers += 1
                }
            }
            var rightPercentage = 0.0
            rightPercentage = (Double(rightAnswers) / Double(questionsInTest.count)) * 100
            rightPercentage = rightPercentage.roundTo(places: 2)
            //-----
            roomsRef.child("rid\((recentExercise?.rid)!)").observeSingleEvent(of: .value, with: { snapshot in
                let values = snapshot.value as? NSDictionary
                let students = values?["students"] as? [String]
                //if, damit nicht Division durch 0
                if students != nil && (students?.count)! > 0 {
                    recentExercise?.exercise.statistics.moveUserToDone(email: (globalUser?.userMail)!, result: Int(rightPercentage))
                    recentExercise?.exercise.statistics.resultDone += Int(rightPercentage)/(recentExercise?.exercise.statistics.done.count)!
                    roomsRef.child("rid\((recentExercise?.rid)!)").child("exercises")
                        .child("eid\((recentExercise?.exercise.exportedExercise.eid)!)")
                        .child("statistics").setValue((recentExercise?.exercise.statistics.toAny())!)
                } else {
                    self.present(AlertHelper.getGotRemovedWhileAnsweringErrorAlert(), animated: true, completion: nil)
                }
            })
            
            globalUser?.userRef?.child("roomsAsStudent").observeSingleEvent(of: .value, with: { snapshot in
                let students = snapshot.value as? [Int]
                if students != nil {
                    globalUser?.userRef?.child("roomsAsStudent").setValue(students)
                }
            })
            //----
            
            testDoneViewController?.rightPercentage = rightPercentage
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
        
        let text = questionsInTest[indexPath.row].question!
        cell.textLabel?.text = text
        cell.textLabel?.textColor = UIColor.black
        
        if let cellLabel = cell.viewWithTag(100) as? UILabel{
            if(questionsInTest[indexPath.row].userChoice == -1){
                cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorDanger())
                cellLabel.text = "ausstehend"
            }
            else{
                cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorAttention())
                cellLabel.text = "beantwortet"
            }
        }
        else{
            let cgrect = CGRect(x: 210, y: 8, width: 100, height: 30)
            let cellLabel = UILabel(frame: cgrect)
            cellLabel.tag = 100
            cellLabel.textColor = UIColor.black
            cellLabel.font.withSize(9)
            if(questionsInTest[indexPath.row].userChoice == -1){
                cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorDanger())
                cellLabel.text = "ausstehend"
            }
            else{
                cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorAttention())
                cellLabel.text = "beantwortet"
            }
            cellLabel.textAlignment = .center
            cellLabel.layer.masksToBounds = true
            cellLabel.layer.cornerRadius = 10

            cell.contentView.addSubview(cellLabel)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as UITableViewCell?
        if let cellLabel = cell?.viewWithTag(100) as? UILabel{
            if(questionsInTest[indexPath.row].userChoice == -1){
                cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorDanger())
                cellLabel.text = "ausstehend"
            }
            else{
                cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorAttention())
                cellLabel.text = "beantwortet"
            }
        }
        
        
        self.chosenQuestion = questionsInTest[indexPath.row]
        self.indexOfChosenQuestion = indexPath.row
        self.performSegue(withIdentifier: "answerQuestion", sender: self)
        
    }
    
    
    //Help-Methoden
    
    
    func realoadQuestionsInTest(){
        self.questionsTableView.reloadData()
    }
}

