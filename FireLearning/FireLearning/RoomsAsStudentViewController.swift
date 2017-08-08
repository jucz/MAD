//
//  RoomsViewController.swift
//  FireLearning
//
//  Created by Admin on 30.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RoomsViewAsStudentController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name = ""
    var chosenRoom: Room?
    var noRooms: Bool = true
    

    @IBOutlet var asStudent: UIView!
    @IBOutlet var asTeacher: UIView!
    @IBAction func toAsTeacher(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBOutlet var tableView: UITableView!
    
    var roomsAsStudent = [Room]()
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Style.roundLabels(lblOne: self.asStudent, lblTwo: self.asTeacher)
        self.navigationItem.setHidesBackButton(true, animated:false);
        
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { snapshot in
            self.roomsAsStudent = [Room]()
            if let rooms = snapshot.value as? [Int] {
                if rooms.count > 0 {
                    self.noRooms = false
                    for room in rooms {
                        roomsRef.child("rid\(room)").observeSingleEvent(of: .value, with: { snapshot in
                            let room = Room(snapshot: snapshot)
                            self.roomsAsStudent.append(room)
                            self.tableView.reloadData()
                        })
                    }
                }
            } else {
                self.noRooms = true
                let tmpRoom = Room(title: "Keine Räume vorhanden", email: "")
                self.roomsAsStudent.append(tmpRoom)
                self.tableView.reloadData()
            }
        })
//        print("\(globalUser?.userRef?.child("roomsAsStudent"))")
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailRoomAsStudent"){
            let detailViewController = segue.destination as? DetailRoomAsStudentViewController
            detailViewController?.room = self.chosenRoom
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
        return self.roomsAsStudent.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        let text = self.roomsAsStudent[indexPath.row].title
        cell.textLabel?.text = text
        Style.styleCell(cell: cell, empty: self.noRooms)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.noRooms == false {
            self.chosenRoom =  self.roomsAsStudent[indexPath.row]
            self.performSegue(withIdentifier: "toDetailRoomAsStudent", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.noRooms == false {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Löschen") { (action, indexPath) in
            self.roomsAsStudent[indexPath.row].removeStudent(email: (globalUser?.user?.email)!)
        }
        return [delete]
    }
    
    func styleView() {
        self.asTeacher.layer.cornerRadius = 10;
        self.asStudent.layer.cornerRadius = 10;
    }
    
    func styleCell(cell: UITableViewCell!) {
        if self.noRooms == true {
            cell.textLabel?.textColor = UIColor.lightGray
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
    }
}
