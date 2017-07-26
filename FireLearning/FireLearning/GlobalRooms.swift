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
    
    public var recentRoom: Room?
    public var roomsAsTeacher = [Room]()
    public var roomsAsStudent = [Room]()
    
    init(_email: String){
        for room in (globalUser?.user?.roomsAsTeacher)! {
            self.addRoomAsTeacherFromFIR(withRid: room)
        }
        for room in (globalUser?.user?.roomsAsStudent)! {
            self.addRoomAsStudentFromFIR(withRid: room)
        }
    }
   
    public func retrieveRoomFromFIR(withRid: Int) {
        let ref = Database.database().reference()
        ref.child("rooms").child("\(withRid)").observeSingleEvent(of: .value, with: { snapshot in
            self.recentRoom = Room(snapshot: snapshot)
        })
    }
    
    public func addRoomAsTeacherFromFIR(withRid: Int) {
        globalUser?.userRef?.observeSingleEvent(of: .value, with: { snapshot in
            self.roomsAsTeacher.append(Room(snapshot: snapshot))
        })
    }
    
    public func addRoomAsStudentFromFIR(withRid: Int) {
        globalUser?.userRef?.observeSingleEvent(of: .value, with: { snapshot in
            self.roomsAsStudent.append(Room(snapshot: snapshot))
        })
    }
    
    
    
    
}
