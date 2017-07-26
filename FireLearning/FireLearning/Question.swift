
import Foundation
import FirebaseDatabase

struct Question {

    static var qids = 0
    
    let qid: Int
    var question: String
    var answer: String
    var possibilities = [String]()
    
    init(anyObject: AnyObject) {
        self.qid = anyObject["qid"] as! Int
        self.question = anyObject["question"] as! String
        self.answer = anyObject["answer"] as! String
        
        if let answers = anyObject["possibilities"] as? [String:String] {
            for answer in answers {
                self.possibilities.append(answer.value)
            }
        }
    }

    init(question: String, answer: String, possibilities: [String]) {
        Question.getRecentQid()
        self.qid = Question.qids
        self.question = question
        self.answer = answer
        self.possibilities = possibilities
    }
    
    init(qid: Int, question: String, answer: String, possibilities: [String]) {
        self.qid = qid
        self.question = question
        self.answer = answer
        self.possibilities = possibilities
    }
    
    init(question: Question) {
        self.qid = question.qid
        self.question = question.question
        self.answer = question.answer
        self.possibilities = question.possibilities
    }
    
    
    //Other
    public mutating func addAnswer(possibility: String){
        self.possibilities.append(possibility)
    }
    
    public func toAny() -> Any {
        let possibilities = Helpers.toAny_orderedByAlphabet(array: self.possibilities)
        return [
            "qid": self.qid,
            "question": self.question,
            "answer": self.answer,
            "possibilities": possibilities
        ]
    }
    
    public static func getRecentQid() {
        Helpers.rootRef.child("qids").observe(.value, with: { snapshot in
            Question.qids = snapshot.value as! Int
        })
        Helpers.rootRef.child("qids").setValue(Question.qids+1)
    }
    
    
    //Setter
    /*public mutating func setQuestion(question: String){
        self.question = question
    }
    
    public mutating func setAnswerIndex(answerIndex: Int){
        self.answerIndex = answerIndex
    }*/
    
    //Getter
    /*public func getQid() -> Int {
        return self.qid
    }
    
    public func getQuestion() -> String {
        return self.question
    }
    
    public func getAnswerIndex() -> Int {
        return self.answerIndex
    }
    
    public func getAnswers() -> [String] {
        return self.answers
    }*/
    
    
}
