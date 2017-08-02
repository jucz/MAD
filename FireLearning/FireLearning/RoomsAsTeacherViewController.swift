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
                for room in rooms {
                    globalRooms?.roomsRef.child("rid\(room)").observeSingleEvent(of: .value, with: { snapshot in
                        let room = Room(snapshot: snapshot)
                        self.roomsAsTeacher.append(room)
                        self.tableView.reloadData()
                    })
                }
            }
        })
                        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "toCreateRoom"){
//            let detailViewController = segue.destination as? CreateRoomViewController
//        }
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
    
    /** Entfernt einen Raum
     **/
    func deleteRoom(index: Int) {
        globalUser?.userRef?.child("roomsAsTeacher").setValue(self.processRemoving(index: index))
    }
    
    /** Aktualisiert alle Arrays und die Firebase, gibt neues roomsAsTeacher-Array des eingeloggten Users zurück,
      * welches dann in der Firebase aktualisiert werden kann
      * ACHTUNG: REIHENFOLGE WICHTIG
     **/
    func processRemoving(index: Int) -> [Int] {
        let rid = self.roomsAsTeacher[index].rid
        
        self.removeStudentsAndThenRoom(room: self.roomsAsTeacher[index])
        self.roomsAsTeacher.remove(at: index)

        var i = 0
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
    
    /** Aktualisiert alle Studenten des Raums in der Firebase und entfernt dann den Raum komplett
     **/
    func removeStudentsAndThenRoom(room: Room) {
        var roomTmp = room
        globalRooms?.roomsRef.child("rid\(roomTmp.rid)").child("students").observeSingleEvent(of: .value, with: { snapshot in
            if let students = snapshot.value as? [String] {
                roomTmp.students = students
                var i = 0
                for _ in students {
                    GlobalRooms.removeStudent(room: roomTmp, index: i)
                    i += 1
                }
            }
            globalRooms?.roomsRef.child("rid\(roomTmp.rid)").removeValue()
        })
    }
    
    
}
