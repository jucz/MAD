
import Foundation


struct Question {

    static var qids = 0
    
    let qid: Int
    var question: String
    var answerIndex: Int
    var answers = [String]()
    
    init(question: String, answerIndex: Int, answers: [String]) {
        Question.getRecentQid()
        self.qid = Question.qids
        self.question = question
        self.answerIndex = answerIndex
        self.answers = answers
    }
    
    init(qid: Int, question: String, answerIndex: Int, answers: [String]) {
        self.qid = qid
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
        //let answers = Helpers.toAny(array: self.answers)
        let answers = Helpers.toAny_orderedByAlphabet(array: self.answers)
        return [
            "qid": self.qid,
            "question": self.question,
            "answerIndex": self.answerIndex,
            "answers": answers
        ]
    }
    
    /*public func toAnyObject() -> AnyObject {
        let answers = Helpers.toAnyObject(array: self.answers)
        return {
            var qid = self.qid;
            var question = self.question;
            var answerIndex = self.answerIndex;
            var answers = answers;
        } as AnyObject
    }*/
    
    
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
