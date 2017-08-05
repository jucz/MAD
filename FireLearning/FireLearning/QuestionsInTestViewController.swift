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


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

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
                recentExercise?.exercise.statistics.moveUserToDone(email: (globalUser?.userMail)!, result: Int(rightPercentage))
                recentExercise?.exercise.statistics.resultDone += Int(rightPercentage)/(recentExercise?.exercise.statistics.done.count)!
                recentExercise?.exercise.statistics.resultComplete += Int(rightPercentage)/(students?.count)!
                roomsRef.child("rid\((recentExercise?.rid)!)").child("exercises")
                    .child("eid\((recentExercise?.exercise.exportedExercise.eid)!)")
                    .child("statistics").setValue((recentExercise?.exercise.statistics.toAny())!)
            })
            globalUser?.userRef?.child("roomsAsStudent").removeValue()
            globalUser?.userRef?.child("roomsAsStudent").setValue(globalUser?.user?.roomsAsStudent)
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
            cellLabel.textColor = UIColor.black
            cellLabel.font.withSize(9)
            
            if(questionsInTest[indexPath.row].userChoice == -1){
                cellLabel.backgroundColor = UIColor(rgb: 0xFF6666)
                cellLabel.text = "ausstehend"
            }
            else{
                cellLabel.backgroundColor = UIColor(rgb: 0xFFCC66)
                //cellLabel.backgroundColor = UIColor(rgb: 0xCCFF66)
                cellLabel.text = "beantwortet"
            }
            
            
            cellLabel.textAlignment = .center
            cellLabel.layer.masksToBounds = true
            cellLabel.layer.cornerRadius = 10
            
        }
        else{
            let cgrect = CGRect(x: 210, y: 8, width: 100, height: 30)
            let cellLabel = UILabel(frame: cgrect)
            cellLabel.tag = 100
            cellLabel.textColor = UIColor.black
            cellLabel.font.withSize(9)
            
            if(questionsInTest[indexPath.row].userChoice == -1){
                cellLabel.backgroundColor = UIColor(rgb: 0xFF6666)
                cellLabel.text = "ausstehend"
            }
            else{
                cellLabel.backgroundColor = UIColor(rgb: 0xFFCC66)
                //cellLabel.backgroundColor = UIColor(rgb: 0xCCFF66)
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
                cellLabel.backgroundColor = UIColor(rgb: 0xFF6666)
                cellLabel.text = "ausstehend"
            }
            else{
                cellLabel.backgroundColor = UIColor(rgb: 0xFFCC66)
                //cellLabel.backgroundColor = UIColor(rgb: 0xCCFF66)
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

