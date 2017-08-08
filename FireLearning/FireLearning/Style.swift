//
//  UsedColors.swift
//  FireLearning
//
//  Created by Admin on 08.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import Foundation

class Style {
       
    public static func roundLabels(lblOne: UIView!, lblTwo: UIView!) {
        lblOne.layer.cornerRadius = 10;
        lblTwo.layer.cornerRadius = 10;
    }
    
    public static func styleCell(cell: UITableViewCell!, empty: Bool) {
        if empty == true {
            cell.textLabel?.textColor = UIColor.lightGray
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
    }
}
