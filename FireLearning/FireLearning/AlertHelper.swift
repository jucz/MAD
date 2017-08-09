//
//  AlertHelper.swift
//  FireLearning
//
//  Created by Admin on 31.07.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper{
    //alert for specified Error Messages for each Text Field
    public static func getErrorAlertForQuestions(_questionTitleText: String,
                                                 _rightAnswerText: String,
                                                 _firstPossText: String,
                                                 _secPossText: String,
                                                 _thrdPossText: String) ->UIAlertController{
        var questionTitleTextFieldError = ""
        var rightAnswerTextFieldError = ""
        var firstPossTextFieldError = ""
        var secPossTextFieldError = ""
        var thrdPossTextFieldError = ""
        if(_questionTitleText == ""){
            questionTitleTextFieldError = "- Keine Frage eingegeben\n"
        }
        if(_rightAnswerText == ""){
            rightAnswerTextFieldError = "- Keine richtige Antwort eingegeben\n"
        }
        if(_firstPossText == ""){
            firstPossTextFieldError = "- Keine erste falsche Möglichkeit eingegeben\n"
        }
        if(_secPossText == ""){
            secPossTextFieldError = "- Keine zweite falsche Möglichkeit eingegeben\n"
        }
        if(_thrdPossText == ""){
            thrdPossTextFieldError = "- Keine dritte falsche Möglichkeit eingegeben\n"
        }
        
        let alertController = UIAlertController(title: "Fehler",
                                                message: "Es wurde nicht alles ausgefüllt:\n" +
                                                    "\(questionTitleTextFieldError)" +
                                                    "\(rightAnswerTextFieldError)" +
                                                    "\(firstPossTextFieldError)" +
                                                    "\(secPossTextFieldError)" +
            "\(thrdPossTextFieldError)",
            preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        return alertController
    }
    
    //simple Alert for Create/edit question formular
    public static func getSimpleQuestionErrorAlert() ->UIAlertController {
        let alertController = UIAlertController(title: "Fehler",
                                                message: "Bitte alle Felder ausfüllen!",
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        return alertController
    }
    
    //simple Alert for Create exercise
    public static func getSimpleExerciseErrorAlert() ->UIAlertController {
        let alertController = UIAlertController(title: "Fehler",
                                                message: "Bitte Titel ausfüllen!",
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        return alertController
    }
    
    //if exercise already answered
    public static func getAlreadyAnsweredErrorAlert() ->UIAlertController {
        let alertController = UIAlertController(title: "Fehler",
                                                message: "Du hast diesen Fragebogen bereits beantwortet!",
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        return alertController
    }
    
    //if student got removed from room while answering
    public static func getGotRemovedWhileAnsweringErrorAlert() ->UIAlertController {
        let alertController = UIAlertController(title: "Fehler",
                                                message: "Du wurdest zwischenzeitlich aus dem Raum entfernt!",
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        return alertController
    }
    
    //settings Error Alert for invalid user email
    public static func getUserNotFoundForBlocked() ->UIAlertController {
        let alertController = UIAlertController(title: "Fehler", message:
            "Bitte gültige E-Mail eingeben!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        return alertController
    }
    
    //alert for showing login errors
    public static func getAuthErrorAlert(_message: String) ->UIAlertController {
        let alertController = UIAlertController(title: "Fehler",
                                                message: _message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        return alertController
    }
    
    //alert if trying to add a user who blocked you
    public static func getYouGotBlockedAlert() ->UIAlertController {
        let alertController = UIAlertController(title: "Fehler", message:
            "Du kannst diesen Nutzer nicht hinzufügen, da du dich auf seiner Blockierliste befindest!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        return alertController
    }
}
