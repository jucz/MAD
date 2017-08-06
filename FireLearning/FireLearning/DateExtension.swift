//
//  DateExtension.swift
//  FireLearning
//
//  Created by Admin on 06.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation


extension Date{
    func getDaysFromTodayToSelf() -> Int{
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: self)
        return components.day!
        
    }
}
