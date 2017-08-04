//
//  QuestionInTest.swift
//  FireLearning
//
//  Created by Admin on 03.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation

class QuestionInTest{
    
    var question: String!
    
    var possibilities: [String]!
    var answer: Int!
    
    var userChoice: Int!
    
    init(_question: String, _userChoice: Int, _answer: Int, _possibilites: [String]){
        self.possibilities = _possibilites
        self.answer = _answer
        self.userChoice = _userChoice
    }
    
    init(_question: Question){
        //fill object with data
        self.question = _question.question
        
        var loggRightAnswer = _question.answer
        
        self.possibilities = []
        self.possibilities.append(_question.answer)
        for each in _question.possibilities{
            self.possibilities.append(each)
        }
        
        
        
        //shuffle
        for i in 0 ..< 4 - 1 {
            let j = Int(arc4random_uniform(UInt32(4 - i))) + i
            if i != j {
                swap(&possibilities[i], &possibilities[j])
            }
        }

        
        //search right Answer
        var i = 0
        for each in self.possibilities{
            if(each == loggRightAnswer){
                self.answer = i
            }
            i += 1
        }
        
        self.userChoice = -1
    }
    
}
