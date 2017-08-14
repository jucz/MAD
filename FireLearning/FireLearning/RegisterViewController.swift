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

class RegisterViewController: UIViewController, UITextFieldDelegate{
    
    //View-Verbindungen
    @IBOutlet var vornameTextField: UITextField!
    @IBOutlet var nachnameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwortTextField: UITextField!
    @IBOutlet var wiederholenTextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction func createAccountButton(_ sender: Any) {
        createAccount()
    }
    
    //System-Methoden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTabAnywhere()
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        displayOKTextField(_textField: vornameTextField)
        displayOKTextField(_textField: nachnameTextField)
        displayOKTextField(_textField: emailTextField)
        displayOKTextField(_textField: passwortTextField)
        displayOKTextField(_textField: wiederholenTextField)
        self.navigationController?.setNavigationBarHidden(false, animated:true)
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Abbrechen", style: .plain, target: self, action: #selector(hideNavBar))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 150), animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: -64), animated: true)
    }
    //Help-Mathoden
    func hideNavBar(){
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public func createAccount(){
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
        
        var pwError = false
        //CheckPasswort
        if( ((passwortTextField.text?.characters.count)! < 6) ||
            (passwortTextField.text! != wiederholenTextField.text!)
            ){
            displayErrorTextField(_textField: passwortTextField)
            displayErrorTextField(_textField: wiederholenTextField)
            error = true
            pwError = true
            var message = "Das Passwort müssen 6 Zeichen lang sein und mit der Wiederholung übereinstimmen!"
            if(error == true){
                message = "\(message)\nBitte auch die anderen Felder ausfüllen!"
            }
            self.present(AlertHelper.getAuthErrorAlert(_message: message),
                         animated: true,
                         completion: nil)
        }
        else{
            displayOKTextField(_textField: passwortTextField)
            displayOKTextField(_textField: wiederholenTextField)
        }
        
        
        
        
        if(error == true){
            if(pwError == false){
                self.present(AlertHelper.getAuthErrorAlert(_message: "Bitte alle Felder ausfüllen!"),
                             animated: true,
                             completion: nil)
            }
        }
        else{
            Auth.auth().createUser(withEmail: emailTextField.text!,
                                       password: passwortTextField.text!) { user, error in
                                        if error == nil {
                                            let userObj = User(email: self.emailTextField!.text!,
                                                               firstname: self.vornameTextField!.text!,
                                                               lastname: self.nachnameTextField!.text!)
                                            userObj.createUserInDB()
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                        else{
                                            if let errCode = AuthErrorCode(rawValue: error!._code) {
                                                
                                                switch errCode {
                                                case .emailAlreadyInUse:
                                                    self.present(AlertHelper.getAuthErrorAlert(_message: "Es gibt bereits einen Account mit dieser E-Mail.\nBitte nehme eine andere E-Mail!"),
                                                                 animated: true,
                                                                 completion: nil)
                                                case .networkError:
                                                    self.present(AlertHelper.getAuthErrorAlert(_message: "Es ist ein Netzwerkfehler aufgetreten.\nBitte überprüfe deine Verbindung!"),
                                                                 animated: true,
                                                                 completion: nil)
                                                case .invalidEmail:
                                                    self.present(AlertHelper.getAuthErrorAlert(_message: "Bitte gib eine richtige E-Mail ein!"),
                                                                 animated: true,
                                                                 completion: nil)
                                                default:
                                                    self.present(AlertHelper.getAuthErrorAlert(_message: "Es ist ein Fehler aufgetreten.\n Bitte versuch es später nochmal!"),
                                                                 animated: true,
                                                                 completion: nil)
                                                }
                                            }
                                        }
            }
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
    
}





