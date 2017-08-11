//
//  DetailExerciseViewController.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController  {
    var exercise: Exercise!
    var room: Room!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet var submitBtn: UIButton!
    @IBAction func submit(_ sender: UIButton) {
        
        roomsRef.child("rid\(self.room.rid)").child("exercises").setValue(self.addExercise().exercisesToAny())
        let ownIndex = self.navigationController?.viewControllers.count
        let viewController = (self.navigationController?.viewControllers[ownIndex!-3])!
        self.navigationController?.popToViewController(viewController, animated: true)
    }
    
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTabAnywhere()
        Style.roundCorners(button: self.submitBtn)
        self.endDatePicker.date = NSDate(timeIntervalSinceNow: (((24 * 60) * 60) * 6)) as Date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addExercise() -> Room! {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let start = formatter.string(from: self.startDatePicker.date)
        let end = formatter.string(from: self.endDatePicker.date)
        self.room.addExercise(exercise: self.exercise, start: start, end: end)
        return self.room
    }
    
    
  
    
}
