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

struct TitleNews{
    var title: String
    var news: String
}

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var chosenExercise: RoomExercise?
    
    var observersNews = [UInt]()
    var noNews = true
    var news = [Int:TitleNews]()
    
    //View-Verbindungen
    @IBOutlet var pendingExercisesTableView: UITableView!
    @IBOutlet var newsTableView: UITableView!
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        globalObservers?.tableViewsPendingExercises.append(self.pendingExercisesTableView)
        globalObservers?.initObserversPendingExercises()

        self.initObserversNews()
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
        if(tableView == self.pendingExercisesTableView){
            return (globalObservers?.pendingExercises.count)!
        }
        else{
//            return self.roomNews.count
            return self.arrayNews().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.pendingExercisesTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingExercisesCell", for: indexPath)

            let text = globalObservers?.pendingExercises[indexPath.row]?.exercise.exportedExercise.title
            cell.textLabel?.text = text
            
            if(globalObservers?.noPendingExercises == true){
                cell.textLabel?.textColor = UIColor.lightGray
                cell.detailTextLabel?.text = ""
                cell.viewWithTag(100)?.removeFromSuperview()
            }
            else{
                cell.detailTextLabel?.text = "aus Klassenraum"
                Database.database().reference().child("rooms").child("rid\((globalObservers?.pendingExercises[indexPath.row]?.rid)!)").child("title").observeSingleEvent(of: .value, with: { (snapshot) in
                    let roomTitle = snapshot.value as! String
                    cell.detailTextLabel?.text = "\(roomTitle)"
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
        //NEUIGKEITEN
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
            let array = self.arrayNews()
            if(self.noNews == false){
                
                cell.textLabel?.text = array[indexPath.row].news
                cell.detailTextLabel?.text = array[indexPath.row].title
                cell.textLabel?.textColor = UIColor.black
                
            } else {
                
                cell.textLabel?.text = array[indexPath.row].news
                cell.detailTextLabel?.text = ""
                cell.textLabel?.textColor = UIColor.lightGray
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.pendingExercisesTableView){
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
        else{
            //…
        }
    }
    
    func initObserversNews(){
        
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { (snapshot) in
            //tableData reset:
            print("OBSERVE ALL NEWS NEW")
            for handle in self.observersNews {
                Database.database().reference().removeObserver(withHandle: handle)
            }
            self.observersNews = []
            self.news = [:]
            let rooms = snapshot.value as? [Int]
            if rooms != nil {
                
                for rid in rooms! {
                    
                    self.observersNews.append(
                        Database.database().reference().child("rooms").child("rid\(rid)").child("news").observe(.value, with: { (snapshot) in
                            let news = snapshot.value as? String
                            if news == nil || news == "" {
                                self.news.removeValue(forKey: rid)
                                if self.news.count == 0 {
                                    print("OBSERVE NEWS: rid\(rid) NO NEWS")
                                    self.noNews = true
                                    self.news[-1] = TitleNews(title: "", news: "Keine Neuigkeiten")
                                    self.newsTableView.reloadData()
                                }
                            } else {
                                Database.database().reference().child("rooms").child("rid\(rid)").child("title").observeSingleEvent(of: .value, with: { snapshot in
                                    let title = snapshot.value as? String
                                    if title != nil {
                                        self.news.removeValue(forKey: -1)
                                        self.noNews = false
                                        self.news[rid] = TitleNews(title: title!, news: news!)
                                        print("OBSERVE NEWS: rid\(rid)")
                                    }
                                    self.newsTableView.reloadData()
                                })
                            }
                        })
                    )
                }
            } else {
                self.noNews = true
                self.news[-1] = TitleNews(title: "", news: "Keine Neuigkeiten")
                self.newsTableView.reloadData()
            }
        })
    }
    
    func arrayNews() -> [TitleNews] {
        let arrayed = self.news.reversed()
        var array = [TitleNews]()
        for n in arrayed {
            array.append(n.value)
        }
        return array
    }
    }
