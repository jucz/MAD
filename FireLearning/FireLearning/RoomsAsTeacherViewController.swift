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
                print("---------\nROOMS VIEW – snapshot: \n\(rooms)\n---------")
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

        //globalUser?.userRef?.child("roomsAsTeacher").removeValue()
        globalRooms?.roomsRef.child("rid\(self.roomsAsTeacher[index].rid)").removeValue()
        
        print("STUDENTS: \(self.roomsAsTeacher[index].students)")
        
        var i = 0
        for _ in self.roomsAsTeacher[index].students {
            GlobalRooms.removeStudent(room: self.roomsAsTeacher[index], index: i)
            i += 1
        }
        let ridToRemove = self.roomsAsTeacher[index].rid
        self.roomsAsTeacher.remove(at: index)
        if self.roomsAsTeacher.count == 0 {
            self.roomsAsTeacher = []
            self.tableView.reloadData()
        }
        
        self.removeRoomAsTeacher(rid: ridToRemove)
        
//        globalUser?.userRef?.child("roomsAsTeacher").observeSingleEvent(of: .value, with: { snapshot in
//            //print("\n_____ROOMS AS TEACHER AKTUALISIEREN____\n")
//            if var rooms = snapshot.value as? [Int] {
//                for _ in rooms {
//                    if rooms[i] == ridToRemove {
//                        rooms.remove(at: i)
//                        i = -1
//                        if i == -1 {
//                            print("\n_____AKTUALISIERE____\n")
//                            //globalUser?.userRef?.child("roomsAsTeacher").setValue(rooms)
//                        }
//                    }
//                }
//            }
//        })
    }
    
    func removeRoomAsTeacher(rid: Int) -> [Int] {
        var newRooms = [Int]()
        globalUser?.userRef?.child("roomsAsTeacher").observeSingleEvent(of: .value, with: { snapshot in
            if let rooms = snapshot.value as? [Int] {
                print("\n********rooms: \(rooms)\n********")
                newRooms = rooms
                print("\n********rooms: \(newRooms)\n********")
                for _ in newRooms {
                    if newRooms[i] == rid {
                        newRooms.remove(at: i)
                        break
                    }
                }
            }
        })
        return newRooms
    }
}
