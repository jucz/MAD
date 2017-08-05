//
//  RoomExercise.swift
//  FireLearning
//
//  Created by Studium on 05.08.17.
//  Copyright © 2017 HS Osnabrueck. All rights reserved.
//

import Foundation

struct RoomExercise {
    var rid: Int
    var exercise: ExerciseExported
    
    init(rid: Int, exercise: ExerciseExported) {
        self.rid = rid
        self.exercise = exercise
    }
}
