//
//  ViewController.swift
//  FireLearning
//
//  Created by Admin on 15.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


var globalUser: GlobalUser?
var globalObservers: Observers?
var roomsAsStudent: RoomsAsStudent?
let roomsRef = Database.database().reference().child("rooms")


class ViewController: UIViewController {

    @IBOutlet var mailOutlet: UITextField!
    @IBOutlet var passwordOutlet: UITextField!
    var loginHit = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.styleNavBarRed()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        do{
            try Auth.auth().signOut()
        }catch{
//            print("Error while signing out!")
        }
        Auth.auth().addStateDidChangeListener { (auth, user) in
//            print("StateFired")
//            print("\nMAIL: \(user?.email)\n")
            if(user != nil){
                let userMail = Helpers.convertEmail(email: (user?.email)!)
                globalUser = GlobalUser(_email: userMail)
                globalObservers = Observers()
                roomsAsStudent = RoomsAsStudent()
                DispatchQueue.main.async(){
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    @IBAction func loginButton(_ sender: Any) {

        //let mail = mailOutlet.text!
//        let mail = "leo@swag.com"
        let mail = "j@app.de"
        
        //let password = passwordOutlet.text!
//        let password = "swag12"
        let password = "j@app.de"
        
        loginHit = true;
        Auth.auth().signIn(withEmail: mail, password: password) { (user, error) in
            if(error != nil){
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .invalidEmail:
                        self.present(AlertHelper.getLoginErrorAlert(_message: "Bitte gib eine gültige E-Mail ein!"),
                                     animated: true,
                                     completion: nil)
                    case .tooManyRequests:
                        self.present(AlertHelper.getLoginErrorAlert(_message: "Du hast zu viele Anfragen gesendet.\nVersuch es später nochmal!"),
                                     animated: true,
                                     completion: nil)
                    case .wrongPassword:
                        self.present(AlertHelper.getLoginErrorAlert(_message: "Bitte gib ein gültiges Passwort ein!"),
                                     animated: true,
                                     completion: nil)
                    case .userNotFound:
                        self.present(AlertHelper.getLoginErrorAlert(_message: "Leider konnte dieser Nutzer nicht gefunden werden!"),
                                     animated: true,
                                     completion: nil)
                    default:
                        self.present(AlertHelper.getLoginErrorAlert(_message: "Es ist ein Fehler aufgetreten.\n Bitte versuch es später nochmal!"),
                                     animated: true,
                                     completion: nil)
                    }
                    
                }
            }
        }
    }
    
    @IBAction func getAccountButton(_ sender: Any) {
        performSegue(withIdentifier: "getAccount", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    public func styleNavBarRed() {
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
//        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: UsedColors.getColorNavBar())
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        self.tabBarController?.tabBar.barTintColor = UIColor.init(rgb: UsedColors.getColorNavBar())
//        self.tabBarController?.tabBar.tintColor = UIColor.white
//        for i in (self.tabBarController?.tabBar.items)! {
//            i.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(rgb: UsedColors.getColorBoardGreen())], for: .normal)
//            i.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
//        }
//        
//    }
    
    
}

