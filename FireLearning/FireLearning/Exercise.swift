
import Foundation
import FirebaseDatabase


class Exercise {
    
    var qids:Int = 0
    var eid: Int
    var title: String
    var questions = [Question]()

    
    init(title: String, qids: Int) {
        self.eid = User.eids
        User.eids += 1
        self.qids = qids
        self.title = title
    }
    
    init(eid: Int,qids: Int, title: String, questions: [Question]) {
        self.eid = eid
        self.qids = qids
        self.title = title
        self.questions = questions
    }
    
    init(anyObject: AnyObject) {
        self.qids = (anyObject["qids"])! as! Int
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
        self.qids = _exercise.qids
        self.title = _exercise.title
        self.questions = _exercise.questions
    }
    
    //Other
    public func addQuestion(question: Question){
        self.questions.append(question)
    }
    
    public func toAny() -> Any {
        var questions = [String:Any]()
        for element in self.questions {
            questions["qid\(element.qid)"] = element.toAny()
        }
        return [
            "qids": self.qids,
            "eid": self.eid,
            "title": self.title,
            "questions": questions
        ]
    }
    
}
