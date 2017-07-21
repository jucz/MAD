//
//  ExercisesViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController, UITableViewDataSource {
    
    
    var name = ""
    
    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "neue Aufgabe",
                                      message: "Namen festlegen",
                                      preferredStyle: .alert)
        
        
        
        let cancelAction = UIAlertAction(title: "Abbrechen",
                                         style: .default)
        let saveAction = UIAlertAction(title: "Weiter",
                                       style: .default) { _ in
                                        
                                        self.name = (alert.textFields?.first?.text)!
                                        
                                        if( self.name != ""){
                                            exerciseName = self.name
                                            self.performSegue(withIdentifier: "createExercise", sender: self)
                                        }
        }
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    @IBOutlet var tableView: UITableView!
    var data = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...20 {
            data.append("aufgabe\(i)")
        }
        
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //table methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! 
        
        let text = data[indexPath.row]
        
        cell.textLabel?.text = text
        
        return cell
    }
}
