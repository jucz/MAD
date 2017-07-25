//
//  SettingsViewController.swift
//  FireLearning
//
//  Created by Admin on 19.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UIViewController {
    @IBOutlet var lastnameText: UITextField!
    @IBAction func button(_ sender: Any) {
        globalUser?.updateName(_name: lastnameText.text!)
        initUI()
    }
    
    func initUI(){
        lastnameText?.text = globalUser?.user?.lastname
    }
    
    
    //System Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
