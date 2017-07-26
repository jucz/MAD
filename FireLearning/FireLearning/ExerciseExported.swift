
import Foundation

struct ExerciseExported {
    
    var exportedExercise: Exercise
    var start: Date
    var end: Date
    var statistics: Statistics
    
    //Constructors
    //Wird benutzt, um ein ExerciseExported-Objekt zu generieren und dieses unter den exercises
    //eines Rooms abzuspeichern
    init(exercise: Exercise, start: Date, end: Date) {
        self.exportedExercise = Exercise(eid: exercise.eid,
                                title: exercise.title,
                                questions: exercise.questions)
        self.start = start
        self.end = end
        self.statistics = Statistics()
    }
    
    init(exerciseOwned: ExerciseExported) {
        self.exportedExercise = exerciseOwned.exportedExercise
        self.start = exerciseOwned.start
        self.end = exerciseOwned.end
        self.statistics = exerciseOwned.statistics
    }
    
    ///JULIAN
    init(anyObject: AnyObject){
        self.exportedExercise = Exercise(anyObject: (anyObject["exportedExercise"])! as AnyObject)
        //ToDo: Datum richtig konvertieren
        //let dateFormatter = DateFormatter()
        self.start = Date()//dateFormatter.date(from: (anyObject["start"] as! String))!
        self.end = Date()//dateFormatter.date(from: (anyObject["end"] as! String))!
        //Ende ToDo
        self.statistics = Statistics(anyObject: anyObject)
    }
    ///

    
    //Others
    public func toAny() -> Any {
        let exportedExercise = self.exportedExercise.toAny()
        let statistics = self.statistics.toAny()
        return [
            "exportedExercise": exportedExercise,
            "start": "\(self.start)",
            "end": "\(self.end)",
            "statistics": statistics
        ]
    }
    
    public mutating func createRoomInDB() {
        Helpers.rootRef.child("rooms").setValue(self.toAny())
    }
    
    
    //Setter
    //not necessary yet
    
    
    //Getter
    /*public func getexportedExercise() -> Exercise {
        return self.exportedExercise
    }
    
    public func getStart() -> Date {
        return self.start
    }
    
    public func getEnd() -> Date {
        return self.end
    }
    
    public func getStatistics() -> Statistics {
        return self.statistics
    }*/
    
    
}
