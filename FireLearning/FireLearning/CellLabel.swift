//
//  CellLabel.swift
//  FireLearning
//
//  Created by Admin on 06.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation
import UIKit


class CellLabel{
    public static func giveStyleForUserChoiceCellLabel(_cellLabel: UILabel, _userChoice: Int, _color1: Int, _color2: Int, _message1: String, _message2: String) ->UILabel{
        _cellLabel.textColor = UIColor.black
        _cellLabel.font.withSize(9)
        _cellLabel.textAlignment = .center
        _cellLabel.layer.masksToBounds = true
        _cellLabel.layer.cornerRadius = 10
        return giveCaseTextColorForUserChoiceCellLabel(_cellLabel: _cellLabel,
                                                       _userChoice: _userChoice,
                                                       _color1: _color1,
                                                       _color2: _color2,
                                                       _message1: _message1,
                                                       _message2: _message2)
    }
    
    public static func giveCaseTextColorForUserChoiceCellLabel(_cellLabel: UILabel, _userChoice: Int, _color1: Int, _color2: Int, _message1: String, _message2: String) ->UILabel{
        if(_userChoice == -1){
            _cellLabel.backgroundColor = UIColor(rgb: _color1)
            _cellLabel.text = _message1
        }
        else{
            _cellLabel.backgroundColor = UIColor(rgb: _color2)
            _cellLabel.text = _message2
        }
        return _cellLabel
    }
}
