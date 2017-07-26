//
//  RoomsViewController.swift
//  FireLearning
//
//  Created by Admin on 26.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RoomsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var rooms = [Room]()
    var name = ""
    var chosenRoom: Room?
    
    //UI
    @IBAction func addRoom(_ sender: UIButton) {
    }
    
    @IBOutlet var tableView: UITableView!
    var roomsAsTeacher = [Room]()
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//         globalUser?.userRef?.child("exercisesOwned").observe(.value, with: { snapshot in
//         let tmpExercises = snapshot.value as? [String: AnyObject]
//         
//         if(tmpExercises != nil){
//         for exercise in tmpExercises!{
//         let tmpExercise = Exercise(_value: exercise.value)
//         self.roomsAsTeacher.append(tmpExercise)
//         }
//         }
//         self.tableView.reloadData()
//         
//         })
        
        //Offline-Modus
        //exercises = (globalUser?.user?.exercisesOwned)!
        
        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailRoom"){
            //let detailViewController = segue.destination as? DetailRoomAsTeacherViewController
            //detailViewController?.exercise = chosenRoom
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //table methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        
        let text = rooms[indexPath.row].title
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenRoom = rooms[indexPath.row]
        self.performSegue(withIdentifier: "toDetailExercise", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
        }
    }
}
