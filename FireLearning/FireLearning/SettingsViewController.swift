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
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        saveChanges()
    }
    
    @IBAction func addUserToBlocked(_ sender: UIButton) {
        addUserToBlockList()
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
            
        }catch{
            self.present(AlertHelper.getAuthErrorAlert(_message: "Es ist ein Fehler aufgetreten.\nBitte versuch es später erneut!"),
                         animated: true,
                         completion: nil)
        }
    }
    
    //Help-Methoden
    
    func saveChanges(){
        var tmpBlockedUsers = blockedUsers
        if(noBlockedUsers == true){
            tmpBlockedUsers = []
        }
        globalUser?.updateUser(_firstname: (firstnameTextField?.text)!,
                               _lastname: (lastnameTextField?.text)!,
                               _blocked: tmpBlockedUsers)
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
                                            if(userEmail != globalUser?.userMail){
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
        self.hideKeyboardOnTabAnywhere()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        globalUser?.userRef?.observe(.value, with: { (snapshot) in
            globalUser?.user = User(snapshot: snapshot)
//            print("ausgeloest")
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Löschen") { (action, indexPath) in
            if (self.noBlockedUsers == false) {
                self.blockedUsers.remove(at: indexPath.row)
                self.saveChanges()
            }
        }
        return [delete]
    }
}
