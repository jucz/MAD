//
//  Sweet.swift
//  FireSwiffer
//
//  Created by Studium on 12.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Sweet {
    
    let key: String!
    let content: String!
    let addedByUser: String!
    let itemRef: DatabaseReference?
    
    init(content: String, addedByUser: String, key: String = ""){
        self.content = content
        self.addedByUser = addedByUser
        self.key = key
        self.itemRef = nil
    }
    
    init(snapshot: DataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        
        let dict = snapshot.value as? NSDictionary
        if let sweetContent = dict?["content"] as? String {
            content = sweetContent
        } else {
            content = ""
        }
        
        if let sweetUser = dict?["addedByUser"] as? String {
            addedByUser = sweetUser
        } else {
            addedByUser = ""
        }
    }
    
    func toAny() -> Any {
        return ["content":content, "addedByUser":addedByUser]
    }
}
