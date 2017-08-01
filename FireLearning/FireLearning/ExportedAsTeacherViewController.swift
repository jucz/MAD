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
    //@IBOutlet var title: UINavigationItem!
    @IBOutlet var start: UILabel!
    @IBOutlet var end: UILabel!
    @IBOutlet var result: UILabel!
    @IBOutlet var doneCount: UILabel!
    @IBOutlet var tableViewDone: UITableView!
    
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title.title = "\(self.exported.exportedExercise.title)"
        self.start.text = "\(self.exported.start)"
        self.end.text = "\(self.exported.end)"
        self.result.text = "\(self.exported.statistics.resultComplete)"
        self.result.text = "\(self.exported.statistics.done.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
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
