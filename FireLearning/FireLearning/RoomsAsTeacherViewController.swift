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
    @IBAction func createRoom(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreateRoom", sender: nil)
    }

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
                print("---------\nROOMS VIEW – snapshot: \(rooms)\n---------")
                for room in rooms {
                    globalRooms?.roomsRef.child("rid\(room)").observeSingleEvent(of: .value, with: { snapshot in
                        let room = Room(snapshot: snapshot)
                        self.roomsAsTeacher.append(room)
                        self.tableView.reloadData()
                        print("++++++++++\nROOMS VIEW – Room added to roomsAsTeacher: \n\(room)\n++++++++++")
                    })
                }
            } else {
                print("---------\nROOMS VIEW - snapshot nil")
            }
        })
        print("\(globalUser?.userRef?.child("roomsAsTeacher"))")
                
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toCreateRoom"){
            let detailViewController = segue.destination as? CreateRoomViewController
        }
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
        globalUser?.userRef?.child("roomsAsTeacher").setValue(self.removeRoomAsTeacher(index: index))
    }
    
    func removeRoomAsTeacher(index: Int) -> [Int] {
        let rid = self.roomsAsTeacher[index].rid
        globalRooms?.roomsRef.child("rid\(rid)").removeValue()
        
        var i = 0
        let room = self.roomsAsTeacher[index]
        self.removeStudents(students: self.roomsAsTeacher[index].students, rid: self.roomsAsTeacher[index].rid)
        self.roomsAsTeacher.remove(at: index)

        i = 0
        for r in (globalUser?.user?.roomsAsTeacher)! {
            if r == rid {
                globalUser?.user?.roomsAsTeacher.remove(at: i)
            }
            i += 1
        }
        if self.roomsAsTeacher.count == 0 {
            self.tableView.reloadData()
            return []
        }
        
        var newRooms = [Int]()
        for r in self.roomsAsTeacher {
            newRooms.append(r.rid)
        }
        return newRooms
    }
    
    func removeStudents(students: [String], rid: Int) {
        print("$$$$$$$$$\nROOM: \(students)\n$$$$$$$$$")
        for s in students {
            let ref = Database.database().reference()
                .child("users")
                .child(Helpers.convertEmail(email: s))
                .child("roomsAsStudent")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let rooms = snapshot.value as? [Int] {
                    var i = 0
                    for id in rooms {
                        print("ROOM-RID: \(rid)")
                        if id == rid {
                            ref.setValue(self.removeRoomFromStudent(rooms: rooms, index: i))
                            break;
                        }
                        i += 1
                    }
                }
            })
        }
    }
    
    func removeRoomFromStudent(rooms: [Int], index: Int) -> [Int] {
        var roomsNew = rooms
        roomsNew.remove(at: index)
        print("ROOMS AS STUDENT NEW: \(roomsNew)")
        return roomsNew
    }
}
