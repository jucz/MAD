//
//  User.swift
//  FireSwiffer
//
//  Created by Studium on 12.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation
import FirebaseAuth

struct RegisteredUser {
    let uid: String
    let email: String
    
    init(userData:User){
        uid = userData.uid
        
        if let mail = userData.providerData.first?.email{
            email = mail
        } else {
            email = ""
        }
    }
    
    init(uid: String, email: String){
        self.uid = uid
        self.email = email
    }
}
