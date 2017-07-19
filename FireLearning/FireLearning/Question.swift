
import Foundation


struct Question {
    
    static var qids: Int = 0
    
    let qid: Int
    var question: String
    var answerIndex: Int
    var answers = [String]()
    
    init(question: String, answerIndex: Int, answers: [String]) {
        self.qid = Question.qids
        Question.qids += 1
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
