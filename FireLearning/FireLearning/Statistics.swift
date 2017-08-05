
import Foundation

struct Statistics {

    var done = [String:Int]() //key: email, value: rounded percent value
    var notDone = [String]() //emails of not done users
    var resultComplete: Int = 0
    var resultDone: Int = 0
    
    //Construtors
    init() {
        self.resultComplete = 0
        self.resultDone = 0
    }
    
    //Wird benutzt, um ein Statistik aus den aus Firebase bezogenen Daten aufzubauen, um dann darauf 
    //calculateResults aufzurufen. Diese berechnete Statistik kann dann in der Firebase die alte
    //unberechnete Statistik überspeichern.
    init(done: [String:Int], notDone: [String], resultComplete: Int, resultDone: Int){
        self.done = done
        self.notDone = notDone
        self.resultComplete = resultComplete
        self.resultDone = resultDone
    }
    
    init(statistics: Statistics){
        self.done = statistics.done
        self.notDone = statistics.notDone
        self.resultComplete = statistics.resultComplete
        self.resultDone = statistics.resultDone
    }
    
    init(anyObject: AnyObject) {
        if let resultDone = anyObject["resultDone"] as? Int {
            self.resultDone = resultDone
        }
        if let resultComplete = anyObject["resultComplete"] as? Int {
            self.resultComplete = resultComplete
        }
        print("STATISTICS done: \(anyObject["done"] as? [String:Int])")
        if let done = anyObject["done"] as? [String:Int] {
            for s in done {
                self.done[s.key] = s.value
            }
        }
        if let notDone = anyObject["notDone"] as? [String] {
            for s in notDone {
                self.notDone.append(s)
            }
        }
    }
    
    //Others
    //Wird aufgerufen, um eine Satistik zu berechnen
    public func calculateResults() {
        var resultComplete: Int = 0
        var resultDone: Int = 0
        
        for user in self.done {
            resultComplete += user.value
        }
        resultDone /= self.done.count
        
        //TODO
        //resultComplete /= Room.getStudents(snapshot: <#T##DataSnapshot#>)
    }
    
    public func toAny() -> Any {
        let notDone = Helpers.toAny(array: self.notDone)

        return [
            "done": self.done,
            "notDone": notDone,
            "resultComplete": self.resultComplete,
            "resultDone": self.resultDone
        ]
    }
    
    public mutating func moveUserToDone(email: String, result: Int) {
        self.done[email] = result
        if self.notDone.count > 0 {
            for index in 0...self.notDone.count-1 {
                if self.notDone[index] == email {
                    self.notDone.remove(at: index)
                    return
                }
            }
        }
    }
    
    public func getIndexedMapOfDone() -> [Int:DoneUser]{
        var doneIndexed = [Int:DoneUser]()
        var i = 0
        for s in self.done {
            doneIndexed[i] = DoneUser(email: s.key, result: s.value)
            i += 1
        }
        print("\nDONE INDEXED: \(doneIndexed)\n")
        return doneIndexed
    }
    
    
    
    //Setter
    //not necessary yet
    
    
    //Getter
    /*public func getDone() -> [String:Int]? {
        return self.done
    }
    
    public func getNotDone() -> [String]? {
        return self.notDone
    }
    
    public func getResultComplete() -> Int {
        return self.resultComplete
    }
    
    public func getResultDone() -> Int {
        return self.resultDone
    }*/
    
    
}
