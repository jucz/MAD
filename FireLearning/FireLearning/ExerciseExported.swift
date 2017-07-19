
import Foundation

struct ExerciseExported {
    
    var eidCopy: Exercise
    var start: Date
    var end: Date
    var statistics: Statistics
    
    //Constructors
    //Wird benutzt, um ein ExerciseExported-Objekt zu generieren und dieses unter den exercises
    //eines Rooms abzuspeichern
    init(exercise: Exercise, start: Date, end: Date) {
        self.eidCopy = Exercise(eid: exercise.eid,
                                title: exercise.title,
                                questions: exercise.questions)
        self.start = start
        self.end = end
        self.statistics = Statistics()
    }
    
    init(exerciseOwned: ExerciseExported) {
        self.eidCopy = exerciseOwned.eidCopy
        self.start = exerciseOwned.start
        self.end = exerciseOwned.end
        self.statistics = exerciseOwned.statistics
    }
    
    //Setter
    //not necessary yet
    
    
    //Getter
    /*public func getEidCopy() -> Exercise {
        return self.eidCopy
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
