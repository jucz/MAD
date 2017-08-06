//
//  DoubleExtension.swift
//  FireLearning
//
//  Created by Admin on 06.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation

extension Double{
    func roundTo(_places: Int) -> Double{
        let devisior = pow(10.0, Double(_places))
        return (self * devisior).rounded() / devisior
    }
}
