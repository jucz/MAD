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
    ///1
    public static func toAny(array: [String]?) -> Any? {
        var list: [String:String] = [:]
        if array == nil {
            return list
        }
        for element in array! {
            list[Helpers.convertEmail(email: element)] = element
        }
        return list
    }
    
    
    public static func toAny_orderedByAlphabet(array: [String]?) -> Any? {
        var index = 0;
        var list: [String:String] = [:]
        if array == nil {
            return list
        }
        let alphabet: [String] = [
            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
        ]
        for element in array! {
            if index > 26 {
                return list
            }
            list[alphabet[index]] = element
            index += 1
        }
        return list
    }

    
    public static func toAny(array: [Int]?) -> Any? {
        var list: [String:Int] = [:]
        if array == nil {
            return list
        }
        for element in array! {
            list["\(element)"] = element
        }
        return list
    }

    
    public static func toAny(array: [Any]?) -> Any? {
        var list: [String:String] = [:]
        if array == nil {
            return list
        }
        for element in array! {
            list["\(element)"] = "\(element)"
        }
        return list
    }

    
    public static func toAny(dict: [String:Any]?) -> Any? {
        var list: [String:String] = [:]
        if dict == nil {
            return list
        }
        for element in dict! {
            list[element.key] = "\(element.value)"
        }
        return list
    }
    
    //Convert all not allowed characters to alternative substrings
    public static func convertEmail(email: String) -> String {
        return email.replacingOccurrences(of: "@", with: "%at").replacingOccurrences(of: ".", with: "%dot")
    }
    
    public static func reconvertEmail(email: String) -> String {
        return email.replacingOccurrences(of: "%at", with: "@").replacingOccurrences(of: "%dot", with: ".")
    }
    
    
}
