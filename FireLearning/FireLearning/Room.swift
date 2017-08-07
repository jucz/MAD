
import Foundation
import FirebaseDatabase

struct Room {
    
    static var rids = 0
    
    var rid: Int
    var title: String
    var admin: String //email of admin
    var description: String?
    var news: String?
    var students = [String]()
    var exercises = [ExerciseExported]()
    
    
    //Plathalter-Konstruktor
    init(title: String, email: String){
        self.rid = -1
        self.title = title
        self.admin = email
    }
    
    init(title: String, email: String, rid: Int){
        self.rid = rid
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
    
    init(snapshot: DataSnapshot) {
        self.rid = Room.getRid(snapshot: snapshot)
        self.title = Room.getTitle(snapshot: snapshot)
        self.admin = Room.getAdmin(snapshot: snapshot)
        self.description = Room.getDescription(snapshot: snapshot)
        self.news = Room.getNews(snapshot: snapshot)
        self.students = Room.getStudents(snapshot: snapshot)
        self.exercises = Room.getExercises(snapshot: snapshot)
    }

    public static func createRoom(title: String, email: String, description: String) {
        Helpers.rootRef.child("rids").observeSingleEvent(of: .value, with: { snapshot in
            let rid = snapshot.value as! Int
            Helpers.rootRef.child("rids").setValue(rid+1)
            var room = Room(title: title, email: email, rid: rid)
            room.description = description
            room.news = "…"
            room.createRoomInDB()
            globalUser?.userRef?.child("roomsAsTeacher").setValue(room.appendRoomToGlobalUser(rid: rid))
        })
    }
    
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
        return [
            "rid": self.rid,
            "title": self.title,
            "admin": self.admin,
            "description": self.description!,
            "news": self.news!,
            "students": self.students,
            "exercises": self.exercisesToAny()
        ]
    }
    
    public static func getRecentRid() {
        Helpers.rootRef.child("rids").observeSingleEvent(of: .value, with: { snapshot in
            let rids = snapshot.value as! Int
            Room.rids = rids
            Helpers.rootRef.child("rids").setValue(rids+1)
        })
    }
    
    
    func appendRoomToGlobalUser(rid: Int) -> [Int] {
        globalUser?.user?.roomsAsTeacher.append(rid)
        return (globalUser?.user?.roomsAsTeacher)!
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
    
    public func removeStudent(index: Int) {
        let userEmail = Helpers.convertEmail(email: self.students[index])
        var students = self.students
        students.remove(at: index)
        roomsRef.child("rid\(self.rid)").child("students").setValue(students)
        let userRef = Database.database().reference().child("users").child(userEmail).child("roomsAsStudent")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            print("\n\(snapshot)\n")
            var roomsAsStudent = snapshot.value as? [Int]
            if roomsAsStudent != nil {
                var index = 0
                for r in roomsAsStudent! {
                    if r == self.rid {
                        roomsAsStudent!.remove(at: index)
                        userRef.setValue(roomsAsStudent)
                        return
                    }
                    index += 1
                }
            }
            
        })
    }
    
    public func removeStudent(email: String) {
        var i = 0
        for s in self.students {
            if s == email {
                break
            }
            i += 1
        }
        let userEmail = Helpers.convertEmail(email: self.students[i])
        var students = self.students
        students.remove(at: i)
        roomsRef.child("rid\(self.rid)").child("students").setValue(students)
        let userRef = Database.database().reference().child("users").child(userEmail).child("roomsAsStudent")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
//            print("\n\(snapshot)\n")
            var roomsAsStudent = snapshot.value as? [Int]
            if roomsAsStudent != nil {
                var index = 0
                for r in roomsAsStudent! {
                    if r == self.rid {
                        roomsAsStudent!.remove(at: index)
                        userRef.setValue(roomsAsStudent)
                        return
                    }
                    index += 1
                }
            }
            
        })
    }
    
}










