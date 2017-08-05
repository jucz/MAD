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
    var noRooms = true
    var chosenRoom: Room?
    

    @IBAction func toAsTeacher(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBOutlet var tableView: UITableView!
    
    var roomsAsStudent = [Room]()
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:false);
        
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { snapshot in
            self.roomsAsStudent = [Room]()
            if let rooms = snapshot.value as? [Int] {
                if rooms.count > 0 {
                    self.noRooms = false
                    print("\nnoRooms: \(self.noRooms)")
                    for room in rooms {
                        roomsRef.child("rid\(room)").observeSingleEvent(of: .value, with: { snapshot in
                            let room = Room(snapshot: snapshot)
                            self.roomsAsStudent.append(room)
                            self.tableView.reloadData()
//                            print("++++++++++\nROOMS VIEW – Room added to roomsAsStudent: \n\(room)\n++++++++++")
                        })
                    }
                } else {
                    print("\nnoRooms: \(self.noRooms)")
                    self.noRooms = true
                    let tmpRoom = Room(title: "Keine Räume vorhanden", email: (globalUser?.user?.email)!)
                    self.roomsAsStudent.append(tmpRoom)
                }
            }
        })
        print("\(globalUser?.userRef?.child("roomsAsStudent"))")
        
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenRoom =  self.roomsAsStudent[indexPath.row]
        self.performSegue(withIdentifier: "toDetailRoomAsStudent", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            var i = 0
            let students = self.roomsAsStudent[indexPath.row].students
            for s in students {
                if s == globalUser?.user?.email {
                    self.roomsAsStudent[indexPath.row].removeStudent(index: i)
                    break
                }
                i += 1
            }
        }
    }
}
