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
        globalUser?.userRef?.observe(.value, with: { snapshot in
            if let values = snapshot.value as? NSDictionary {
                self.roomsAsTeacher = [Room]()
                self.roomsAsStudent = [Room]()
                if let roomsAsTeacher = values["roomsAsTeacher"] as? [Int] {
                    for room in roomsAsTeacher {
                        self.addRoomAsTeacherFromFIR(withRid: room)
                    }
                }
                if let roomsAsStudent = values["roomsAsStudent"] as? [Int] {
                    for room in roomsAsStudent {
                        self.addRoomAsStudentFromFIR(withRid: room)
                    }
                }
            }
        })
    }
    
    public func addRoomAsTeacherFromFIR(withRid: Int) {
        self.roomsRef.child("rid\(withRid)").observe(.value, with: { snapshot in
            let room = Room(snapshot: snapshot)
            self.roomsAsTeacher.append(room)
            print("++++++++++\nGlobalRooms – Room added to roomsAsTeacher: \n\(room)\n++++++++++")
        })
    }
    
    public func addRoomAsStudentFromFIR(withRid: Int) {
        self.roomsRef.child("rid\(withRid)").observe(.value, with: { snapshot in
            let room = Room(snapshot: snapshot)
            self.roomsAsStudent.append(room)
            print("++++++++++\nGlobalRooms – Room added to roomsAsStudent: \n\(room)\n++++++++++")
        })
    }
    
    //    public func retrieveRecentRoomFromFIR(withRid: Int) {
    //        self.roomsRef.child("\(withRid)").observeSingleEvent(of: .value, with: { snapshot in
    //            self.recentRoom = Room(snapshot: snapshot)
    //        })
    //    }
    //
    //    public func retrieveRoomAsTeacherFromFIR(withRid: Int) {
    //        self.roomsRef.child("\(withRid)").observeSingleEvent(of: .value, with: { snapshot in
    //            self.roomsAsTeacher.append(Room(snapshot: snapshot))
    //        })
    //    }
    //
    //    public func retrieveRoomAsStudentFromFIR(withRid: Int) {
    //        self.roomsRef.child("\(withRid)").observeSingleEvent(of: .value, with: { snapshot in
    //            self.roomsAsStudent.append(Room(snapshot: snapshot))
    //        })
    //    }

    
    
}
