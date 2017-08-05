//
//  ExportedAsTeacherViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class ExportedAsTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var rid: Int = -1
    var exported: ExerciseExported!
    var isEditingExercise = false
    //var noOneDone: true
    @IBOutlet var exerciseTitle: UINavigationItem!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var result: UILabel!
    @IBOutlet var doneCount: UILabel!
    @IBOutlet var tableViewDone: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomsRef.child("rid\(self.rid)")
            .child("exercises")
            .child("eid\(self.exported.exportedExercise.eid)")
            .child("statistics")
            .observe(.value, with: { snapshot in
                
                let values = snapshot.value as? NSDictionary
                
                self.exerciseTitle.title = self.exported.exportedExercise.title
                self.startDate.text = (self.exported.start)!
                self.endDate.text = (self.exported.end)!
                let resultComplete = values?["resultComplete"] as! Int
                print("RESULT COMPLETE: \(resultComplete)")
                self.result.text = "\(resultComplete)"
                let done = values?["done"] as! [String:Int]
                self.doneCount.text = "\(done.count)"
            })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //table methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exported.statistics.done.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        cell.textLabel?.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
}
