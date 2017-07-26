
import Foundation
import FirebaseDatabase


struct Exercise {
    
    static var eids = 0;
        
    var eid: Int
    var title: String
    var questions = [Int:Question]()
    
    //Constructors
    init(title: String) {
        Exercise.getRecentEid()
        self.eid = Exercise.eids
        self.title = title
    }
    
    init(eid: Int, title: String, questions: [Int:Question]) {
        self.eid = eid
        self.title = title
        self.questions = questions
    }
    
    init(anyObject: AnyObject){
        self.eid = (anyObject["eid"])! as! Int
        self.title = (anyObject["title"])! as! String
        //Loop durch alle Fragen:
        let allQuestions = (anyObject["questions"])! as! [String:AnyObject]
        for q in allQuestions {
            let qTmp = Question(anyObject: q.value)
            self.questions[qTmp.qid] = qTmp
        }
    }
    
    init(_value: AnyObject){
        self.title = _value["title"] as! String
        self.eid = _value["eid"] as! Int
        var tmpQuestions = [Int:Question]()
        
        var counter = 0
        //Fragen
        for eachQuestion in (_value["questions"] as? [String:AnyObject])! {
            let tmpQuestionTitle = eachQuestion.value["question"] as! String
            let tmpAnswer = eachQuestion.value["answer"] as! String
            
            //antworten
            var tmpPossibilites = [String]()
            for eachPossibility in (eachQuestion.value["possibilities"] as? [String:String])!{
                tmpPossibilites.append(eachPossibility.value)
            }
            
            let tmpQuestion = Question(question: tmpQuestionTitle, answer: tmpAnswer, possibilities: tmpPossibilites)
            tmpQuestions[counter] = (tmpQuestion)
            counter += 1
        }
        self.questions = tmpQuestions

    }
    
    //Other
    public mutating func addQuestion(question: Question){
        self.questions[question.qid] = question
    }
    
    public func toAny() -> Any {
        var questions = [String:Any]()
        for element in self.questions {
            questions["qid\(element.key)"] = element.value.toAny()
        }
        return [
            "eid": self.eid,
            "title": self.title,
            "questions": questions
        ]
    }
    
    public static func getRecentEid() {
        Helpers.rootRef.child("eids").observe(.value, with: { snapshot in
            Exercise.eids = snapshot.value as! Int
        })
        Helpers.rootRef.child("eids").setValue(Exercise.eids+1)
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
