//
//  pendingExercisesViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class PendingExercisesViewController: UIViewController {

    var pendingExercises = [Exercise]()
    //View-Verbindungen
    @IBAction func switchToCreatedExercisesBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBOutlet var pendingExercisesTable: UITableView!
    
    //System-Methoden
    override func viewDidLoad() {
        pendingExercises = []
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:false);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Table-Methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingExercises.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingExerciseCell", for: indexPath)
        
        let text = pendingExercises[indexPath.row].title
        
        cell.textLabel?.text = text
        
        return cell
    }
    

}
