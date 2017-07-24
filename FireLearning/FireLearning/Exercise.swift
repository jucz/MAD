
import Foundation



struct Exercise {
    
    static var eids = 0;
        
    var eid: Int
    var title: String
    var questions = [Int:Question]()
    
    //Constructors
    init(title: String) {
        //self.eid = Exercise.getNewEid()
        self.eid = Exercise.eids
        Exercise.eids += 1
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
    
    /*public func toAnyObject() -> AnyObject {
        var questions = [String:AnyObject]()
        for element in self.questions {
            questions["\(element.key)"] = element.value.toAnyObject()
        }
        return {
            var eid = self.eid;
            var title = self.title;
            var questions = questions;
        } as AnyObject
    }*/
    
    /*public static func getNewEid() -> Int {
        Helpers.rootRef.child("eids").observe(.value, with: { snapshot in
            let values = snapshot.value as? [String:AnyObject]
            let eidTmp = values?["eids"] as! Int
            Helpers.rootRef.child("eids").setValue("\(eidTmp+1)")
        })
        return Int(eid)
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
