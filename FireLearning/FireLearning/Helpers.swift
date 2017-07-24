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
    static var userTmp: User?

    //Converts an Array to a directory which can be saved in Firebase as Any
    ///1
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
    
    public static func toAny_orderedByAlphabet(array: [String]?) -> Any? {
        if array == nil {
            return nil
        }
        let alphabet: [String] = [
            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
        ]
        var index = 0;
        var list: [String:String] = [:]
        for element in array! {
            if index > 26 {
                return list
            }
            list[alphabet[index]] = element
            index += 1
        }
        return list
    }
    
    /*public static func toAnyObject(array: [String]?) -> AnyObject? {
        if array == nil {
            return nil
        }
        var list: [String:String] = [:]
        for element in array! {
            list[Helpers.convertEmail(email: element)] = element
        }
        return list as AnyObject?
    }*/
    ///ENDE 1
    
    ///2
    public static func toAny(array: [Int]?) -> Any? {
        if array == nil {
            return nil
        }
        var list: [String:String] = [:]
        for element in array! {
            list["\(element)"] = "\(element)"
        }
        return list
    }
    
    /*public static func toAnyObject(array: [Int]?) -> AnyObject? {
        if array == nil {
            return nil
        }
        var list: [String:Int] = [:]
        for element in array! {
            list["\(element)"] = element
        }
        return list as AnyObject?
    }*/
    ///ENDE 2
    
    ///3
    public static func toAny(array: [Any]?) -> Any? {
        if array == nil {
            return nil
        }
        var list: [String:String] = [:]
        for element in array! {
            list["\(element)"] = "\(element)"
        }
        return list
    }
    
    /*public static func toAnyObject(array: [AnyObject]?) -> AnyObject? {
        if array == nil {
            return nil
        }
        var list: [String:String] = [:]
        for element in array! {
            list["\(element)"] = "\(element)"
        }
        return list as AnyObject?
    }*/
    ///ENDE 3
    
    ///4
    public static func toAny(dict: [String:Any]?) -> Any? {
        if dict == nil {
            return nil
        }
        var res = [String:String]()
        for element in dict! {
            res[element.key] = "\(element.value)"
        }
        return res
    }
    
    /*public static func toAnyObject(dict: [String:AnyObject]?) -> AnyObject? {
        if dict == nil {
            return nil
        }
        var res = [String:String]()
        for element in dict! {
            res[element.key] = "\(element.value)"
        }
        return res as AnyObject?
    }*/
    ///ENDE 4
    
    //Convert all not allowed characters to alternative substrings
    public static func convertEmail(email: String) -> String {
        return email.replacingOccurrences(of: "@", with: "at").replacingOccurrences(of: ".", with: "dot")
    }
    
    public static func initUser(withEmailAsPath: String) {
        print("initUser")
        Helpers.rootRef.child("users").child(withEmailAsPath).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            let firstname = value?["firstname"] as? String ?? ""
            let lastname = value?["lastname"] as? String ?? ""
            var user = User(email: email, firstname: firstname, lastname: lastname)
            user.blocked = User.getBlocked(snapshot: snapshot)
            User.getExercisesOwned(snapshot: snapshot)
        })
    }
    
    public static func getUser(withEmailAsPath: String) -> User? {
        Helpers.initUser(withEmailAsPath: withEmailAsPath)
        print("getUser")
        return Helpers.userTmp
    }
    
}
