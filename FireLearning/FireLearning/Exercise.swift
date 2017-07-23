
import Foundation



struct Exercise {
        
    var eid: Int
    var title: String
    var questions = [Int:Question]()
    
    //Constructors
    init(title: String) {
        self.eid = Exercise.getNewEid()
        self.title = title
    }
    
    init(eid: Int, title: String, questions: [Int:Question]) {
        self.eid = eid
        self.title = title
        self.questions = questions
    }
    
    init(eid: Int, title: String, questions: [Int:Any]) {
        self.eid = eid
        self.title = title
        //todo
    }
    
    //Other
    public mutating func addQuestion(question: Question){
        self.questions[question.qid] = question
    }
    
    public func toAny() -> Any {
        var questions = [String:Any]()
        for element in self.questions {
            questions["\(element.key)"] = element.value.toAny()
        }
        return [
            "eid": self.eid,
            "title": self.title,
            "questions": questions
        ]
    }
    
    public static func getNewEid() -> Int {
        var eidTmp: Int = 0
        Helpers.rootRef.child("eids").observe(.value, with: { snapshot in
            eidTmp = snapshot.value as! Int
        })
        Helpers.rootRef.child("eids").setValue(eidTmp+1)
        return eidTmp
    }
    
    
    //Setter
    /*public mutating func setEid(eid: Int) {
        self.eid = eid
    }
    
    public mutating func setTitle(title: String){
        self.title = title
    }
    
    public mutating func setQuestions(questions: [Int:Question]){
        self.questions = questions
    }*/
    
    
    //Getter
    /*public func getEid() -> Int {
        return self.eid
    }
    
    public func getTitle() -> String {
        return self.title
    }
    
    public func getQuestions() -> [Int:Question] {
        return self.questions
    }*/
    
}
