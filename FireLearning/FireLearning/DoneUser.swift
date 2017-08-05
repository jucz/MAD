//
//  DoneUser.swift
//  FireLearning
//
//  Created by Studium on 06.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation

struct DoneUser {
    var email: String
    var result: Int
    
    init(email: String, result: Int){
        self.email = email
        self.result = result
    }
}
