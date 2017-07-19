
import Foundation

struct Room {
    
    static var rids: Int = 0
    
    let rid: Int
    var title: String
    var admin: String //email of admin
    var description: String?
    var news: String?
    var students: [String]?
    var exercises: [ExerciseExported]?
    
    
    init(title: String, email: String){
        self.rid = Room.rids
        Room.rids += 1
        self.title = title
        self.admin = email
    }
    
    init(room: Room){
        self.rid = room.rid
        self.title = room.title
        self.admin = room.admin
        self.description = room.description
        self.news = room.news
        self.students = room.students
        self.exercises = room.exercises
    }
    
    public mutating func addStudent(email: String) {
        self.students?.append(email)
    }
    
    public mutating func addExercise(exercise: Exercise, start: Date, end: Date) {
        self.exercises?.append(ExerciseExported(exercise: exercise, start: start, end: end))
    }
    

    
    
}
