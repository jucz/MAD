//
//  CreateRoomViewController.swift
//  FireLearning
//
//  Created by Admin on 01.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit


class CreateRoomViewController: UIViewController {
   
    @IBAction func submit(_ sender: UIButton) {
        self.createRoom()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet var nameForm: UITextField!
    @IBOutlet var descriptionForm: UITextView!
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
        self.nameForm.text = ""
        self.descriptionForm.text = ""
        self.nameForm.placeholder = "Name"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createRoom() {
        Room.createRoom(title: self.nameForm.text!, email: (globalUser?.user?.email)!, description: self.descriptionForm.text!)
        
    }
    
    func styleView() {
        self.descriptionForm.layer.cornerRadius = 10
    }
    
}
