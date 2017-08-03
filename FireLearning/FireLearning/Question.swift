
import Foundation
import FirebaseDatabase

struct Question {
    
    let qid: Int
    var question: String
    var answer: String
    var possibilities = [String]()
    
    init(anyObject: AnyObject) {
        self.qid = anyObject["qid"] as! Int
        self.question = anyObject["question"] as! String
        self.answer = anyObject["answer"] as! String
        
        if let answers = anyObject["possibilities"] as? [String:String] {
            self.possibilities.append(answers["a"]!)
            self.possibilities.append(answers["b"]!)
            self.possibilities.append(answers["c"]!)
        }
    }

    init(question: String,qid: Int, answer: String, possibilities: [String]) {
        self.qid = qid
        self.question = question
        self.answer = answer
        self.possibilities = possibilities
    }
    
    init(question: Question) {
        self.question = question.question
        self.qid = question.qid
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
    
    public func checkIfCorrect(answer: String) -> Bool {
        if answer == self.answer {
            return true
        }
        return false
    }
    
    //Shuffle possibilities und answer zu neuem Array
    public func shuffleQuestion() -> [String] {
        var array = self.possibilities
        array.append(self.answer)
        for i in 0 ..< array.count - 1 {
            let j = Int(arc4random_uniform(UInt32(array.count - i))) + i
            if i != j {
                swap(&array[i], &array[j])
            }
        }
        return array
    }

    
    
}
