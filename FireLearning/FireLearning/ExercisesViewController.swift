//
//  ExercisesViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController, UITableViewDataSource {
    
    
    
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "createExercise", sender: self)
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
