
import Foundation
import FirebaseDatabase


struct Exercise {
    
    static var qids: Int = 0
        
    var eid: Int
    var title: String
    var questions = [Question]()
    
    //Constructors
//    init(title: String) {
//        Exercise.getRecentEid()
//        self.eid = Exercise.eids
//        self.title = title
//    }
    
    init(title: String) {
        self.eid = User.eids
        User.eids += 1
        self.title = title
    }
    
    init(eid: Int, title: String, questions: [Question]) {
        self.eid = eid
        self.title = title
        self.questions = questions
    }
    
    init(anyObject: AnyObject) {
        Exercise.qids = (anyObject["qids"])! as! Int
        self.eid = (anyObject["eid"])! as! Int
        self.title = (anyObject["title"])! as! String
        //Loop durch alle Fragen:
        let allQuestions = (anyObject["questions"]) as? [String:AnyObject]
        if(allQuestions != nil){
            for q in allQuestions! {
                let qTmp = Question(anyObject: q.value)
                self.questions.append(qTmp)
            }
        }
    }
    
    init(_exercise: Exercise){
        self.eid = _exercise.eid
        self.title = _exercise.title
        self.questions = _exercise.questions
    }
    
    //Other
    public mutating func addQuestion(question: Question){
        self.questions.append(question)
    }
    
    public func toAny() -> Any {
        var questions = [String:Any]()
        for element in self.questions {
            questions["qid\(element.qid)"] = element.toAny()
        }
        return [
            "qids": Exercise.qids,
            "eid": self.eid,
            "title": self.title,
            "questions": questions
        ]
    }
    /*
    public static func getRecentEid() {
        Helpers.rootRef.child("eids").observe(.value, with: { snapshot in
            Exercise.eids = snapshot.value as! Int
        })
        Helpers.rootRef.child("eids").setValue(Exercise.eids+1)
    }*/
    
    
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
