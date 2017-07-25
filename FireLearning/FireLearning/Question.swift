
import Foundation


struct Question {

    static var qids = 0
    
    let qid: Int
    var question: String
    var answer: String
    var possibilities = [String]()
    
    init(question: String, answer: String, possibilities: [String]) {
    //init(question: String, answerIndex: Int, answers: [String]) {
        Question.getActualQid()
//>>>>>>> dfc84ca1f5d39b27d989bd695afa04e46e951beb
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
        let possibilities = Helpers.toAny(array: self.possibilities)
        //let answers = Helpers.toAny(array: self.answers)
        //let answers = Helpers.toAny_orderedByAlphabet(array: self.answers)
        return [
            "qid": self.qid,
            "question": self.question,
            "answer": self.answer,
            "possibilities": possibilities
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
    
    
    public static func getActualQid() {
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
