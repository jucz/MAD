
import Foundation

struct Statistics {

    var done = [String:Int]() //key: email, value: rounded percent value
    var notDone = [String]() //emails of not done users
    var resultComplete: Int
    var resultCompleteDone: Int
    
    //Construtors
    init() {
        self.resultComplete = 0
        self.resultCompleteDone = 0
    }
    
    
}
