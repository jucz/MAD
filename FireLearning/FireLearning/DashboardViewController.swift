//
//  DashboardViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //pendingExercisesTable data
    var noPendingExercises = false
    var pendingExercises = [Int:RoomExercise]()
    var chosenExercise: RoomExercise?
    
    //newsTable data
    var noRoomNews = false
    var roomsRef = [Int]()
    var roomNews = [Int:String]()
    var roomTitles = [Int:String]()
    
    //View-Verbindungen
    
    @IBOutlet var pendingExercisesTableView: UITableView!
    @IBOutlet var newsTableView: UITableView!
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPendingExercise()
        loadRoomNews()
        pendingExercisesTableView.dataSource = self
        pendingExercisesTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.delegate = self
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
        if(tableView == pendingExercisesTableView){
            return pendingExercises.count
        }
        else{
            return roomNews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == pendingExercisesTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingExercisesCell", for: indexPath)
            let text = pendingExercises[indexPath.row]?.exercise.exportedExercise.title
            cell.textLabel?.text = text
            if(noPendingExercises == true){
                cell.textLabel?.textColor = UIColor.lightGray
                cell.detailTextLabel?.text = ""
            }
            else{
                cell.detailTextLabel?.text = "aus Klassenraum"
                Database.database().reference().child("rooms").child("rid\((pendingExercises[indexPath.row]?.rid)!)").child("title").observeSingleEvent(of: .value, with: { (snapshot) in
                    let roomTitle = snapshot.value as! String
                    cell.detailTextLabel?.text = "aus \(roomTitle)"
                })
                
                let endDate = pendingExercises[indexPath.row]?.exercise.getEndAsDate()
                
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
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
            if(noRoomNews == false){
                print("nicht leer")
                var refToRoom = roomsRef[indexPath.row]
                cell.textLabel?.text = roomNews[refToRoom]
                cell.detailTextLabel?.text = "aus \(roomTitles[refToRoom]!)"
                cell.textLabel?.textColor = UIColor.black
            }
            else{
                print("leer")
                cell.textLabel?.text = roomNews[indexPath.row]
                cell.detailTextLabel?.text = ""
                cell.textLabel?.textColor = UIColor.lightGray
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == pendingExercisesTableView){
            if(noPendingExercises == false){
                let endDate = pendingExercises[indexPath.row]?.exercise.getEndAsDate()
                
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
                self.chosenExercise = self.pendingExercises[indexPath.row]
                self.performSegue(withIdentifier: "startTest", sender: self)
            }
        }
        else{
            if(noRoomNews == false){
                
            }
            
        }
    }
    
    //Help-Methoden
    
    func loadPendingExercise(){
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { (snapshot) in
            //tableData reset:
            self.pendingExercises = [:]
            let tmpRoomIDs = snapshot.value as? [Int]
            if(tmpRoomIDs != nil){
                var recentStudentRoomIDs = [Int:Int]()
                for each in tmpRoomIDs!{
                    recentStudentRoomIDs[each] = each
                }
                
                
                //neue Observer registireren
                print("\(recentStudentRoomIDs.count)")
                var counter = 0
                
                var freeCounters = [Int]()
                for eachRoomID in recentStudentRoomIDs {
                    Database.database().reference().child("rooms").child("rid\(eachRoomID.key)").child("exercises").observe(.value, with: { (snapshot) in
                        if let tmpData = snapshot.value as? [String : AnyObject] {
                            //delete old room-exercises from data-array
                            for each in self.pendingExercises{
                                freeCounters.append(each.key)
                                if(each.value.rid == eachRoomID.key){
                                    self.pendingExercises.removeValue(forKey: each.key)
                                }
                            }
                            
                            //add recent room-exercises to data-array
                            for each in tmpData{
                                let tmpExportedExercise = ExerciseExported(anyObject: each.value)
                                let endDate = tmpExportedExercise.getEndAsDate()
                                var notExpired = false
                                if endDate != nil && endDate! > Date() {
                                    notExpired = true
                                }
                                let notDone = tmpExportedExercise.statistics.done[(globalUser?.userMail)!] == nil
                                if notExpired && notDone {
                                    if(freeCounters.count > 0){
                                        self.pendingExercises[freeCounters[0]] = RoomExercise(rid: eachRoomID.key, exercise: tmpExportedExercise)
                                        freeCounters.remove(at: 0)
                                    }
                                    else{
                                        self.pendingExercises[counter] = RoomExercise(rid: eachRoomID.key, exercise: tmpExportedExercise)
                                        counter = counter + 1
                                    }
                                    print(self.pendingExercises)
                                }
                            }
                        }
                        
                        
                        self.pendingExercisesTableView.reloadData()
                        
                    })
                }
            }
        })
    }
    
    func loadRoomNews(){
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { (snapshot) in
            //tableData reset:
            self.pendingExercises = [:]
            let tmpRoomIDs = snapshot.value as? [Int]
            if(tmpRoomIDs != nil){
                var recentStudentRoomIDs = [Int:Int]()
                for each in tmpRoomIDs!{
                    recentStudentRoomIDs[each] = each
                }
                var counter = 0
                
                var freeCounters = [Int]()
                for eachRoomID in recentStudentRoomIDs {
                    Database.database().reference().child("rooms").child("rid\(eachRoomID.key)").observe(.value, with: { (snapshot) in
                        //delete old room-news from data-array
                        print("fired\(eachRoomID.key)")
                        for each in self.roomNews{
                            freeCounters.append(each.key)
                            if(each.key == eachRoomID.key){
                                var i = 0
                                for roomRef in self.roomsRef{
                                    if(roomRef == eachRoomID.key){
                                        self.roomsRef.remove(at: i)
                                    }
                                    i += 1
                                }
                                self.roomNews.removeValue(forKey: each.key)
                                self.roomTitles.removeValue(forKey: each.key)
                            }
                        }
                        
                        
                        let value = snapshot.value as? NSDictionary
                        
                        var roomMessage = value?["news"] as! String
                        let roomTitle = value?["title"] as! String
                        let students = value?["students"] as! [String]
                        
                        for student in students{
                            if(student == globalUser?.user?.email){
                                if(roomMessage == ""){
                                    roomMessage = "keine News"
                                }
                                
                                self.roomsRef.append(eachRoomID.key)
                                self.roomNews[eachRoomID.key] = roomMessage
                                self.roomTitles[eachRoomID.key] = roomTitle
                                break
                            }
                        }
                        
                        
                        if(self.roomNews.count == 0){
                            self.noRoomNews = true
                            self.roomNews[0] = "Keine News"
                        }
                        else{
                            self.noRoomNews = false
                        }
                        self.newsTableView.reloadData()
                    })
                }
            }
        })
    }
}
