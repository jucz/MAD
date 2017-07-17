
import Foundation

struct ExerciseExported {
    
    static var eids: Int = 0
    
    var eidCopy: Exercise
    var start: Date
    var end: Date
    var statistics: Statistics
    
    init(exercise: Exercise, start: Date, end: Date) {
        self.eidCopy = Exercise(eid: exercise.getEid(),
                                title: exercise.getTitle(),
                                questions: exercise.getQuestions())
        self.start = start
        self.end = end
        self.statistics = Statistics()
    }
    
}
