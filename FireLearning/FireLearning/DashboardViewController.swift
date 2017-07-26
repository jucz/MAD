//
//  DashboardViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DashboardViewController: UIViewController {
    
    ///JULIAN
    var room: Room?
    ///ENDE JULIAN

    override func viewDidLoad() {
        super.viewDidLoad()
        ///JULIAN TEST
        retrieveRoomFromFIR(withRid: 0)
        ///ENDE JULIAN TEST
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///JULIAN
    public func retrieveRoomFromFIR(withRid: Int) {
        let ref = Database.database().reference()
        ref.child("rooms").child("\(withRid)").observeSingleEvent(of: .value, with: { snapshot in
            self.room = Room(snapshot: snapshot)
        })
    }
    ///ENDE JULIAN
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
