
import Foundation


struct Question {
    
    static var qids: Int = 0
    
    let qid: Int
    var question: String
    var answer: String
    var possibilities = [String]()
    
    init(question: String, answer: String, possibilities: [String]) {
        self.qid = Question.qids
        Question.qids += 1
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
        return [
            "qid": self.qid,
            "question": self.question,
            "answer": self.answer,
            "possibilities": possibilities
        ]
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
