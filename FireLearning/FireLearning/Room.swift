
import Foundation
import FirebaseDatabase

struct Room {
    
    static var rids = 0
    
    let rid: Int
    var title: String
    var admin: String //email of admin
    var description: String?
    var news: String?
    var students = [String]()
    var exercises = [ExerciseExported]()
    
    
    init(title: String, email: String){
        Room.getRecentRid()
        self.rid = Room.rids
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
    
    ///JULIAN
    init(snapshot: DataSnapshot) {
        self.rid = Room.getRid(snapshot: snapshot)
        self.title = Room.getTitle(snapshot: snapshot)
        self.admin = Room.getAdmin(snapshot: snapshot)
        self.description = Room.getDescription(snapshot: snapshot)
        self.news = Room.getNews(snapshot: snapshot)
        self.students = Room.getStudents(snapshot: snapshot)
        self.exercises = Room.getExercises(snapshot: snapshot)
        
        //print("___Room: \(self)____")
    }
    ///ENDE JULIAN
    
    //Others
    public mutating func addStudent(email: String) {
        self.students.append(email)
    }
    
    public mutating func addExercise(exercise: Exercise, start: String?, end: String?) {
        self.exercises.append(ExerciseExported(exercise: exercise, start: start, end: end))
    }
    
    //Others
    public func createRoomInDB() {
        Helpers.rootRef.child("rooms").child("rid\(self.rid)").setValue(self.toAny())
    }
    
    public func toAny() -> Any {
//        var exercises = [String:Any]()
//        for element in self.exercises {
//            exercises["eid\(element.exportedExercise.eid)"] = element.toAny()
//        }
        return [
            "rid": self.rid,
            "title": self.title,
            "admin": self.admin,
            "description": self.description!,
            "news": self.news!,
            "students": self.students,
            "exercises": self.exercisesToAny()//exercises
        ]
    }
    
    public static func getRecentRid() {
        Helpers.rootRef.child("rids").observe(.value, with: { snapshot in
            Room.rids = snapshot.value as! Int
        })
        Helpers.rootRef.child("rids").setValue(Room.rids+1)
    }
    
    ///GETTER
    public static func getAdmin(snapshot: DataSnapshot) -> String {
        let values = snapshot.value as? NSDictionary
        return values?["admin"] as? String ?? ""
    }
    
    public static func getDescription(snapshot: DataSnapshot) -> String {
        let values = snapshot.value as? NSDictionary
        return values?["description"] as? String ?? ""
    }
    
    public static func getNews(snapshot: DataSnapshot) -> String {
        let values = snapshot.value as? NSDictionary
        return values?["news"] as? String ?? ""
    }
    
    public static func getRid(snapshot: DataSnapshot) -> Int {
        let values = snapshot.value as? NSDictionary
        if let rid = values?["rid"] as? Int {
            return rid
        } else {
            return -1
        }
    }
    
    public static func getTitle(snapshot: DataSnapshot) -> String {
        let values = snapshot.value as? NSDictionary
        return values?["title"] as? String ?? ""
    }

    
    public static func getStudents(snapshot: DataSnapshot) -> [String] {
        let values = snapshot.value as? NSDictionary
        var students = [String]()
        if let allStudents = values?["students"] as? [String] {
            for s in allStudents {
                students.append(s)
            }
        }
        return students
    }
    
    public static func getExercises(snapshot: DataSnapshot) -> [ExerciseExported] {
        let values = snapshot.value as? NSDictionary
        var exercises = [ExerciseExported]()
        if let anyObject = values?["exercises"] as? [String:AnyObject] {
            for element in anyObject {
                let eTmp = ExerciseExported(anyObject: element.value)
                exercises.append(eTmp)
            }
        }
        return exercises
    }
    
    public func exercisesToAny() -> Any {
        var exercises = [String:Any]()
        for element in self.exercises {
            exercises["eid\(element.exportedExercise.eid)"] = element.toAny()
        }
        return exercises
    }
    
    ///SETTER
    public mutating func setAdmin(email: String) {
        self.admin = email
    }
    
}










