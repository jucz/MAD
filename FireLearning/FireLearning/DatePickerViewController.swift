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
    
    @IBAction func submit(_ sender: UIButton) {
        
        self.room.addExercise(exercise: self.exercise, start: self.startDatePicker.date, end: self.endDatePicker.date)
        globalRooms?.roomsRef.child("rid\(self.room.rid)").child("exercises").setValue(self.room.exercisesToAny())
        let ownIndex = self.navigationController?.viewControllers.count
        let viewController = (self.navigationController?.viewControllers[ownIndex!-3])!
        self.navigationController?.popToViewController(viewController, animated: true)
    }
    
    
    //System
    override func viewDidLoad() {
        super.viewDidLoad()
        self.endDatePicker.date = NSDate(timeIntervalSinceNow: (((24 * 60) * 60) * 6)) as Date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
  
    
}
