//
//  RoomsAsStudent.swift
//  FireLearning
//
//  Created by Studium on 04.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation
import FirebaseDatabase


class RoomsAsStudent {
    
    var rooms = [Room]()
    
    init() {
        globalUser?.userRef?.child("roomsAsStudent").observe(.value, with: { snapshot in
            self.rooms = [Room]()
            if let rooms = snapshot.value as? [Int] {
                if rooms.count > 0 {
                    for room in rooms {
                        roomsRef.child("rid\(room)").observeSingleEvent(of: .value, with: { snapshot in
                            let room = Room(snapshot: snapshot)
                            self.rooms.append(room)
//                            print("++++++++++\nROOMS VIEW – Room added to roomsAsStudent: \n\(room)\n++++++++++")
                        })
                    }
                } else {
                    let tmpRoom = Room(title: "Keine Räume vorhanden", email: (globalUser?.user?.email)!)
                    self.rooms.append(tmpRoom)
                }
            }
        })
    }

    
}
