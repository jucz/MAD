//
//  UsedColors.swift
//  FireLearning
//
//  Created by Admin on 05.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class UsedColors{
    //desc.: class with only static getter-methods
    //       to return the hex values of certain
    //       colors used in different situations
    //          e.g.: getColorDanger returns specific red
    //       -> important for having consistent colors in app
    
    
    //Colors:
    
    //Situations: -less than 3 days for left for answering a exercise
    //            -user has not answered a question
    //            -user gave wrong answer
    public static func getColorDanger() -> Int {
        return 0xFF6666
    }
    
    //Situations: -more than 7 days left for answering a exercise
    //            -user gave right answer
    public static func getColorOK() -> Int {
        return 0x66FF66
    }
    
    //Situations: -between 3 and 7 days left for answering a exercise
    //            -user has answered a question
    //            -user has chosen a question
    public static func getColorAttention() -> Int {
        return 0xFFCC66
    }
}
