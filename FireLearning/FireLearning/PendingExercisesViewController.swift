//
//  pendingExercisesViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseDatabase



class PendingExercisesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var chosenExercise: RoomExercise?

    
    
    //View-Verbindungen
    @IBOutlet var pendingEx: UIView!
    @IBOutlet var createdEx: UIView!
    @IBAction func switchToCreatedExercisesBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBOutlet var pendingExercisesTable: UITableView!
    
    //System-Methoden
    override func viewDidLoad() {
        //        self.pendingExercises = [:]
        self.hideKeyboardOnTabAnywhere()
        
        Style.roundLabels(lblOne: self.pendingEx, lblTwo: self.createdEx)
        
        globalObservers?.tableViewsPendingExercises.append(self.pendingExercisesTable)
        globalObservers?.initObserversPendingExercises()
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:false);
        pendingExercisesTable.reloadData()
        pendingExercisesTable.dataSource = self
        pendingExercisesTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Data transfer to Test View Controller
        if(segue.identifier == "startTest"){
            questionsInTest = []
            recentExercise = self.chosenExercise
            
            for each in (self.chosenExercise?.exercise.exportedExercise.questions)!{
                //question template convert to real question
                let realQuestion = QuestionInTest(_question: each)
                //questionsInTestViewController?.questions.append(realQuestion)
                questionsInTest.append(realQuestion)
            }
        }
    }
    //Table-Methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (globalObservers?.pendingExercises.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingExerciseCell", for: indexPath)
        let text = globalObservers?.pendingExercises[indexPath.row]?.exercise.exportedExercise.title
        
        cell.textLabel?.text = text
        if globalObservers?.pendingExercises.count == 1 && globalObservers?.pendingExercises[0] != nil && globalObservers?.pendingExercises[0]?.rid == -1 {
            globalObservers?.noPendingExercises = true
        } else {
            globalObservers?.noPendingExercises = false
        }
        
        if(globalObservers?.noPendingExercises == true){
            cell.textLabel?.textColor = UIColor.lightGray
            cell.detailTextLabel?.text = ""
            cell.viewWithTag(100)?.removeFromSuperview()
            
        } else {
            cell.detailTextLabel?.text = "aus Klassenraum"
            Database.database().reference().child("rooms").child("rid\((globalObservers?.pendingExercises[indexPath.row]?.rid)!)").child("title").observeSingleEvent(of: .value, with: { (snapshot) in
                let titleVal = snapshot.value as? String
                if titleVal != nil {
                    cell.detailTextLabel?.text = "\(titleVal!)"
                    cell.detailTextLabel?.textColor = UIColor.lightGray
                    
                } else {
                    cell.detailTextLabel?.text = ""
                }
            })
            let endDate = globalObservers?.pendingExercises[indexPath.row]?.exercise.getEndAsDate()
            
            var daysLeft: Int
            if endDate != nil {
                daysLeft = (endDate?.getDaysFromTodayToSelf())!
            } else {
                daysLeft = 0
            }
            cell.textLabel?.textColor = UIColor.black
            if let cellLabel = cell.viewWithTag(100) as? UILabel{
                if(daysLeft >= 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
                }
                else if(daysLeft >= 3 && daysLeft < 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorAttention())
                }
                else{
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorDanger())
                }
            }
            else{
                let cgrect = CGRect(x: 210, y: 8, width: 100, height: 30)
                let cellLabel = UILabel(frame: cgrect)
                cellLabel.tag = 100
                cellLabel.textColor = UIColor.black
                cellLabel.font.withSize(9)
                cellLabel.text = "noch \(daysLeft) Tage"
                
                if(daysLeft >= 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
                }
                else if(daysLeft >= 3 && daysLeft < 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorAttention())
                }
                else{
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorDanger())
                }
                cellLabel.textAlignment = .center
                cellLabel.layer.masksToBounds = true
                cellLabel.layer.cornerRadius = 10
                
                cell.contentView.addSubview(cellLabel)
            }
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(globalObservers?.noPendingExercises == false){
            let endDate = globalObservers?.pendingExercises[indexPath.row]?.exercise.getEndAsDate()
            
            var daysLeft: Int
            if endDate != nil {
                daysLeft = (endDate?.getDaysFromTodayToSelf())!
            } else {
                daysLeft = 0
            }
            
            let cell = tableView.cellForRow(at: indexPath) as UITableViewCell?
            if let cellLabel = cell?.viewWithTag(100) as? UILabel{
                if(daysLeft >= 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorOK())
                }
                else if(daysLeft >= 3 && daysLeft < 7){
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorAttention())
                }
                else{
                    cellLabel.backgroundColor = UIColor(rgb: UsedColors.getColorDanger())
                }
            }
            self.chosenExercise = globalObservers?.pendingExercises[indexPath.row]
            self.performSegue(withIdentifier: "startTest", sender: self)
        }
    }
}
