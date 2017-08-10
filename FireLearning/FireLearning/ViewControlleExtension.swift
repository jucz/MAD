//
//  ViewControlleExtension.swift
//  FireLearning
//
//  Created by Admin on 10.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardOnTabAnywhere() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
}
