//
//  ExportedAsTeacherViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class ExportedAsTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        self.exerciseTitle.title = self.exported.exportedExercise.title
        print("STARTDATUM: \((self.exported.start)!)")
        print("ENDDATUM: \((self.exported.end)!)")
        self.startDate.text = (self.exported.start)!
        self.endDate.text = (self.exported.end)!
        self.result.text = "\(self.exported.statistics.resultComplete)"
        self.doneCount.text = "\(self.exported.statistics.done.count)"
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
