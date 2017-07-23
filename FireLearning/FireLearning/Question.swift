
import Foundation


struct Question {
    
    let qid: Int
    var question: String
    var answerIndex: Int
    var answers = [String]()
    
    init(question: String, answerIndex: Int, answers: [String]) {
        self.qid = Question.getNewQid()
        self.question = question
        self.answerIndex = answerIndex
        self.answers = answers
    }
    
    init(question: Question) {
        self.qid = question.qid
        self.question = question.question
        self.answerIndex = question.answerIndex
        self.answers = question.answers
    }
    
    
    //Other
    public mutating func addAnswer(answer: String){
        self.answers.append(answer)
    }
    
    public func toAny() -> Any {
        let answers = Helpers.toAny(array: self.answers)
        return [
            "qid": self.qid,
            "question": self.question,
            "answerIndex": self.answerIndex,
            "answers": answers
        ]
    }
    
    
    public static func getNewQid() -> Int {
        var qidTmp: Int = 0
        Helpers.rootRef.child("qids").observe(.value, with: { snapshot in
            qidTmp = snapshot.value as! Int
        })
        Helpers.rootRef.child("eids").setValue(qidTmp+1)
        return qidTmp
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
