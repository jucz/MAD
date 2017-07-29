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
    
    var name = ""
    var chosenRoom: Room?
    
    //UI
    @IBAction func addRoom(_ sender: UIButton) {
    }
    
    @IBOutlet var tableView: UITableView!
    //var roomsAsTeacher = [Room]()
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalUser?.userRef?.child("roomsAsTeacher").observe(.value, with: { snapshot in
            globalRooms?.retrieveRoomsFromFIR(globalUser: globalUser)
            self.tableView.reloadData()
        })
        
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
        if globalRooms != nil {
            //print("\nZEILEN: \((globalRooms?.roomsAsTeacher.count)!)\n")
            return (globalRooms?.roomsAsTeacher.count)!
        } else {
            //print("\nZEILEN: 0\n")
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        if globalUser != nil && (globalRooms?.roomsAsTeacher.count)! > 0 {
            let text = (globalRooms?.roomsAsTeacher[indexPath.row].title)! as String
            print("\nTEXT: \(text)\n")
            cell.textLabel?.text = text
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenRoom =  globalRooms?.roomsAsTeacher[indexPath.row]
        self.performSegue(withIdentifier: "toDetailRoom", sender: nil)
        self.tableView.reloadData()
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
