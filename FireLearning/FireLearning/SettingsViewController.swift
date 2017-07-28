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

class SettingsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var blockedUsers = [String]()
    
    //View-Verbindungen
    @IBOutlet var firstnameTextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    
    @IBOutlet var blockedTableView: UITableView!
    
    
    @IBAction func saveButton(_ sender: Any) {
        saveChanges()
        initUI()
    }
    
    
    //Help-Methoden
    func initUI(){
        lastnameTextField?.text = globalUser?.user?.lastname
        firstnameTextField?.text = globalUser?.user?.firstname
        if(globalUser?.user?.blocked == nil){
            blockedUsers = []
        }
        else{
            blockedUsers = (globalUser?.user?.blocked)!
        }
        
        print("globalblock\(globalUser?.user?.blocked)")

        blockedTableView.reloadData()
    }
    
    func saveChanges(){
        globalUser?.updateUser(_firstname: (firstnameTextField?.text)!, _lastname: (lastnameTextField?.text)!, _blocked: blockedUsers)
        
    }
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blockedTableView.dataSource = self
        blockedTableView.delegate = self
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Table-Methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blockedCell", for: indexPath)
        
        let text = blockedUsers[indexPath.row]
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            blockedUsers.remove(at: indexPath.row)
            let tmpBlocked = blockedUsers
            saveChanges()
            blockedUsers = tmpBlocked
            print(blockedUsers)
            initUI()
        }
    }
}
