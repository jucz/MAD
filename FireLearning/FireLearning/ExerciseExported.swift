
import Foundation

class ExerciseExported {
    
    var exportedExercise: Exercise!
    var start: String?
    var end: String?
    var statistics: Statistics!
    
    //Constructors
    //Wird benutzt, um ein ExerciseExported-Objekt zu generieren und dieses unter den exercises
    //eines Rooms abzuspeichern
    init(exercise: Exercise, start: String?, end: String?) {
        self.exportedExercise = Exercise(eid: exercise.eid,
                                         qids: exercise.qids,
                                         title: exercise.title,
                                         questions: exercise.questions)
        self.start = start ?? ""
        self.end = end ?? ""
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
        self.start = anyObject["start"] as? String ?? ""
        self.end = anyObject["end"] as? String ?? ""
        self.statistics = Statistics(anyObject: (anyObject["statistics"] as? AnyObject)!)
    }
    ///

    
    //Others
    public func toAny() -> Any {
        let exportedExercise = self.exportedExercise.toAny()
        let statistics = self.statistics.toAny()
  
        return [
            "exportedExercise": exportedExercise,
            "start": self.start ?? "",
            "end": self.end ?? "",
            "statistics": statistics
        ]
    }
    
    public func createRoomInDB() {
        Helpers.rootRef.child("rooms").setValue(self.toAny())
    }
    

    
    public func getStart() -> String {
        if self.start == nil {
            return ""
        }
        return self.start!
    }
    
    public func getStartAsDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        if self.start == nil {
            return nil
        }
        return formatter.date(from: self.start!)
    }
    
    public func getEnd() -> String {
        if self.end == nil {
            return ""
        }
        return self.end!
    }
    
    public func getEndAsDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        if self.end == nil {
            return nil
        }
        return formatter.date(from: self.end!)
    }
    
    public func alreadyAnswered(email: String) -> Bool {
        if self.statistics.done[email] == nil {
            return false
        }
        return true
    }
    
    public func started() -> Bool {
        if self.getStartAsDate()! <= Date() {
            return true
        }
        return false
    }
    
    public func expired() -> Bool {
        if self.getEndAsDate()! < Date() {
            return true
        }
        return false
    }

    
}
