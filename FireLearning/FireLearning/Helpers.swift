//
//  Helpers.swift
//  FireLearning
//
//  Created by Studium on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class Helpers {

    static var rootRef = Database.database().reference()

    //Converts an Array to a directory which can be saved in Firebase as Any
    public static func toAny(array: [String]?) -> Any? {
        if array == nil {
            return nil
        }
        var list: [String:String] = [:]
        for element in array! {
            list[Helpers.convertEmail(email: element)] = element
        }
        return list
    }
    
    public static func toAny(array: [Int]?) -> Any? {
        if array == nil {
            return nil
        }
        var list: [String:Int] = [:]
        for element in array! {
            list["\(element)"] = element
        }
        return list
    }
    
    //Convert all not allowed characters to alternative substrings
    public static func convertEmail(email: String) -> String {
        return email.replacingOccurrences(of: "@", with: "at").replacingOccurrences(of: ".", with: "dot")
    }
}
