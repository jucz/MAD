//
//  RegisterViewController.swift
//  
//
//  Created by Admin on 17.07.17.
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    let rootRef = Database.database().reference()
    
    //Custom Back-Button
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backToLogin", sender: self)
    }
    
    //Form TextField:
    @IBOutlet var vornameTextField: UITextField!
    @IBOutlet var nachnameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwortTextField: UITextField!
    @IBOutlet var wiederholenTextField: UITextField!
    
    
    @IBAction func createAccountButton(_ sender: Any) {
        var success = createAccout()
        
        if(success == true){
            performSegue(withIdentifier: "backToLogin", sender: self)
        }
        else{
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayOKTextField(_textField: vornameTextField)
        displayOKTextField(_textField: nachnameTextField)
        displayOKTextField(_textField: emailTextField)
        displayOKTextField(_textField: passwortTextField)
        displayOKTextField(_textField: wiederholenTextField)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func createAccout() -> Bool{
        var error = false;
        
        //CheckVorname
        if( (vornameTextField.text?.isEmpty)!){
            displayErrorTextField(_textField: vornameTextField)
            error = true
        }
        else{
            displayOKTextField(_textField: vornameTextField)
        }
        
        //CheckNachname
        if( (nachnameTextField.text?.isEmpty)!){
            displayErrorTextField(_textField: nachnameTextField)
            error = true
        }
        else{
            displayOKTextField(_textField: nachnameTextField)
        }
        
        //CheckEmail
        if( (emailTextField.text?.isEmpty)!){
            displayErrorTextField(_textField: emailTextField)
            error = true
        }
        else{
            displayOKTextField(_textField: emailTextField)
        }
        
        //CheckPasswort
        if( ((passwortTextField.text?.characters.count)! < 6) ||
            (passwortTextField.text! != wiederholenTextField.text!)
            ){
            displayErrorTextField(_textField: passwortTextField)
            displayErrorTextField(_textField: wiederholenTextField)
            error = true
        }
        else{
            displayOKTextField(_textField: passwortTextField)
            displayOKTextField(_textField: wiederholenTextField)
        }
        
        
        
        if(error == true){
            return false
        }
        else{
            Auth.auth().createUser(withEmail: emailTextField.text!,
                                       password: passwortTextField.text!) { user, error in
                                        if error == nil {
                                            print("user erstellt")
                                        }
            }
            
            //JULIAN
            let user = User(email: emailTextField.text!,
                            firstname: vornameTextField.text!,
                            lastname: nachnameTextField.text!)
            self.createUserInDB(user: user)
            //ENDE JULIAN
            
            return true
        }
    }
    
    public func displayErrorTextField(_textField: UITextField){
        let myColor : UIColor = UIColor.red
        _textField.layer.borderColor = myColor.cgColor
        _textField.layer.borderWidth = 1.0
    }
    public func displayOKTextField(_textField: UITextField){
        let myColor : UIColor = UIColor.lightGray
        _textField.layer.borderColor = myColor.cgColor
        _textField.layer.borderWidth = 1.0
    }
    
    //JULIAN
    public func createUserInDB(user: User) {
        let email: String = self.convertEmail(email: user.getEmail())
        self.rootRef.setValue(email)
        self.rootRef.child(email).setValue(user.toAnyObject())
    }
    
    private func convertEmail(email: String) -> String {
        return email.replacingOccurrences(of: "@", with: "at").replacingOccurrences(of: ".", with: "dot")
    }
    //ENDE JULIAN
}





