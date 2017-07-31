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
    var noBlockedUsers = false
    var blockedUsers = [String]()
    
    //View-Verbindungen
    @IBOutlet var firstnameTextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    @IBOutlet var blockedTableView: UITableView!
    
    @IBAction func saveButton(_ sender: Any) {
        saveChanges()
        //initUI()
    }
    
    @IBAction func addUserToBlocked(_ sender: Any) {
        addUserToBlockList()
    }
    
    
    //Help-Methoden
    
    func saveChanges(){
        globalUser?.updateUser(_firstname: (firstnameTextField?.text)!, _lastname: (lastnameTextField?.text)!, _blocked: blockedUsers)
        
    }
    
    func addUserToBlockList(){
        presentEnterUserAlert()
        
    }
    
    func presentEnterUserAlert(){
        let alert = UIAlertController(title: "Nutzer zu Blockierliste hinzufügen", message:
            "E-Mail des Nutzers eingeben", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Hinzufügen",
                                       style: .default) { _ in
                                        guard let textField = alert.textFields?.first,
                                            let user = textField.text else {
                                                return
                                        }
                                        if(user != ""){
                                            let userEmail = Helpers.convertEmail(email: user)
                                            
                                            Database.database().reference().child("users").observeSingleEvent(of: .value, with: {snapshot in
                                                let value = snapshot.value as? [String: AnyObject]
                                                for each in value!{
                                                    if(userEmail == each.key){
                                                        globalUser?.user?.blocked.append(user)
                                                        globalUser?.userRef?.child("blocked").setValue(globalUser?.user?.blocked)
                                                        return
                                                    }
                                                }
                                                
                                                self.present(AlertHelper.getUserNotFoundForBlocked(), animated: true, completion: nil)
                                                
                                            })
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Abbrechen",
                                         style: .default)
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalUser?.userRef?.observe(.value, with: { (snapshot) in
            globalUser?.user = User(snapshot: snapshot)
            print("ausgeloest")
            self.lastnameTextField?.text = globalUser?.user?.lastname
            self.firstnameTextField?.text = globalUser?.user?.firstname
            if(globalUser?.user?.blocked == nil){
                self.blockedUsers = []
                self.noBlockedUsers = true
            }
            else{
                if(globalUser?.user?.blocked.count == 0){
                    self.blockedUsers = ["kein Nutzer in der Blockierliste"]
                    self.noBlockedUsers = true
                }
                else{
                    self.blockedUsers = (globalUser?.user?.blocked)!
                    self.noBlockedUsers = false
                }
            }
            self.blockedTableView.reloadData()
        })
        blockedTableView.dataSource = self
        blockedTableView.delegate = self
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
        if(noBlockedUsers == true){
            cell.textLabel?.textColor = UIColor.lightGray
        }
        else{
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(noBlockedUsers == false){
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete && noBlockedUsers == false) {
            blockedUsers.remove(at: indexPath.row)
            saveChanges()
        }
    }
}
