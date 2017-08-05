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
            .observe(.value, with: { snapshot in
                
                let anyObject = snapshot.value as? AnyObject
                if anyObject != nil && anyObject?["exportedExercise"] != nil {
                    self.exported = ExerciseExported(anyObject: anyObject!)
                
                    self.exerciseTitle.title = self.exported.exportedExercise.title
                    self.startDate.text = (self.exported.start)!
                    self.endDate.text = (self.exported.end)!
                    let resultComplete = self.exported.statistics.resultComplete
                    print("RESULT COMPLETE: \(resultComplete)")
                    self.result.text = "\(resultComplete)"
                    self.doneCount.text = "\(self.exported.statistics.done.count)"
                    
                    self.tableViewDone.reloadData()
                    self.tableViewDone.allowsMultipleSelectionDuringEditing = false
                    self.tableViewDone.dataSource = self
                    self.tableViewDone.delegate = self
                }
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
        let doneIndexed = self.exported.statistics.getIndexedMapOfDone()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        cell.textLabel?.text = "\(Helpers.reconvertEmail(email:(doneIndexed[indexPath.row]?.email)!)): \((doneIndexed[indexPath.row]?.result)!) %"
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
