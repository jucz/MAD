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

class RoomsViewAsTeacherController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name = ""
    var chosenRoom: Room?
    
    //UI
    @IBAction func toStudents(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRoomsAsStudent", sender: nil)
    }
    
    @IBOutlet var tableView: UITableView!
    var roomsAsTeacher = [Room]()
    //var roomsAsStudent = [Room]()
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
                
        globalUser?.userRef?.child("roomsAsTeacher").observe(.value, with: { snapshot in
            self.roomsAsTeacher = [Room]()
            if let rooms = snapshot.value as? [Int] {
                for room in rooms {
                    globalRooms?.roomsRef.child("rid\(room)").observeSingleEvent(of: .value, with: { snapshot in
                        let room = Room(snapshot: snapshot)
                        self.roomsAsTeacher.append(room)
                        self.tableView.reloadData()
                        print("++++++++++\nROOMS VIEW – Room added to roomsAsTeacher: \n\(room)\n++++++++++")
                    })
                }
            }
        })
        print("\(globalUser?.userRef?.child("roomsAsTeacher"))")
                
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailRoomAsTeacher"){
            let detailViewController = segue.destination as? DetailRoomAsTeacherViewController
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
        return self.roomsAsTeacher.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        let text = self.roomsAsTeacher[indexPath.row].title
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenRoom =  self.roomsAsTeacher[indexPath.row]
        self.performSegue(withIdentifier: "toDetailRoomAsTeacher", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            self.deleteRoom(index: indexPath.row)
        }
    }
    
    func deleteRoom(index: Int) {
        let room = Room(room: self.roomsAsTeacher[index])
        print("STUDENTS: \(room.students)")
        self.roomsAsTeacher.remove(at: index)
        var index = 0
        for _ in room.students {
            GlobalRooms.removeStudent(room: room, index: index)
            index += 1
        }
        globalRooms?.roomsRef.child("rid\(room.rid)").removeValue()
        globalUser?.userRef?.child("roomsAsTeacher").observeSingleEvent(of: .value, with: { snapshot in
            if var rooms = snapshot.value as? [Int] {
                var index = 0
                for r in rooms {
                    if r == room.rid {
                        rooms.remove(at: index)
                        print("ROOMS.COUNT: \(rooms.count)")
                        globalUser?.userRef?.child("roomsAsTeacher").setValue(rooms)
                        if rooms.count == 0 {
                            self.tableView.reloadData()
                        }
                        return
                    }
                    index += 1
                }
            }
        
        })
    }
    
}
