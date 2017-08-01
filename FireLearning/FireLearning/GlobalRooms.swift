//
//  GlobalUser.swift
//  FireLearning
//
//  Created by Admin on 26.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//
import UIKit
import Foundation
import FirebaseDatabase

class GlobalRooms {
    
    public let roomsRef = Database.database().reference().child("rooms")
    public var recentRoom: Room?
    public var roomsAsTeacher = [Room]()
    public var roomsAsStudent = [Room]()
    
    init(globalUser: GlobalUser?){
        self.retrieveRoomsFromFIR(globalUser: globalUser)
    }
    
    public func retrieveRoomsFromFIR(globalUser: GlobalUser?) {
        globalUser?.userRef?.observeSingleEvent(of: .value, with: { snapshot in
            if let values = snapshot.value as? NSDictionary {
                
                self.roomsAsTeacher = [Room]()
                self.roomsAsStudent = [Room]()
                
                if let roomsAsTeacher = values["roomsAsTeacher"] as? [Int] {
                    self.retrieveRoomsAsTeacherFromFIR(rooms: roomsAsTeacher)
                }
                if let roomsAsStudent = values["roomsAsStudent"] as? [Int] {
                    self.retrieveRoomsAsStudentFromFIR(rooms: roomsAsStudent)
                }
            }
        })
    }
    
    public func retrieveRoomsAsTeacherFromFIR(rooms: [Int]) {
        self.roomsAsTeacher = [Room]()
        for room in rooms {
            self.addRoomAsTeacherFromFIR(withRid: room)
        }
    }
    
    public func retrieveRoomsAsStudentFromFIR(rooms: [Int]) {
        self.roomsAsStudent = [Room]()
        for room in rooms {
            self.addRoomAsStudentFromFIR(withRid: room)
        }
    }
    
    public func addRoomAsTeacherFromFIR(withRid: Int) {
        self.roomsRef.child("rid\(withRid)").observeSingleEvent(of: .value, with: { snapshot in
            let room = Room(snapshot: snapshot)
            self.roomsAsTeacher.append(room)
            print("++++++++++\nGlobalRooms – Room added to roomsAsTeacher: \n\(room)\n++++++++++")
        })
    }
    
    public func addRoomAsStudentFromFIR(withRid: Int) {
        self.roomsRef.child("rid\(withRid)").observeSingleEvent(of: .value, with: { snapshot in
            let room = Room(snapshot: snapshot)
            self.roomsAsStudent.append(room)
            print("++++++++++\nGlobalRooms – Room added to roomsAsStudent: \n\(room)\n++++++++++")
        })
    }
    
    public static func removeStudent(room: Room, index: Int) {
        let userEmail = Helpers.convertEmail(email: room.students[index])
        var students = room.students
        students.remove(at: index)
        globalRooms?.roomsRef.child("rid\(room.rid)").child("students").setValue(students)
        let userRef = Database.database().reference().child("users").child(userEmail).child("roomsAsStudent")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            print("\n\(snapshot)\n")
            var roomsAsStudent = snapshot.value as? [Int]
            if roomsAsStudent != nil {
                var index = 0
                for r in roomsAsStudent! {
                    if r == room.rid {
                        roomsAsStudent!.remove(at: index)
                        userRef.setValue(roomsAsStudent)
                        return
                    }
                    index += 1
                }
            }
            
        })
    }
    
}
