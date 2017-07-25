
import Foundation

struct Statistics {

    var done = [String:Int]() //key: email, value: rounded percent value
    var notDone = [String]() //emails of not done users
    var resultComplete: Int
    var resultDone: Int
    
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
        //resultComplete /= ANZAHL ALLER SCHUELER DES ZUGEHOERIGEN RAUMS
    }
    
    public func toAny() -> Any {
        let notDone = Helpers.toAny(array: self.notDone)
        var done = [String:String]()
        for element in self.done {
            done[element.key] = "\(element.value)"
        }
        return [
            "done": done,
            "notDone": notDone,
            "resultComplete": self.resultComplete,
            "resultDone": self.resultDone
        ]
    }
    
    /*public func toAnyObject() -> AnyObject {
        let notDone = Helpers.toAnyObject(array: self.notDone)
        var done = [String:String]()
        for element in self.done {
            done[element.key] = "\(element.value)"
        }
        return {
            var done = done;
            var notDone = notDone;
            var resultComplete = self.resultComplete;
            var resultDone = self.resultDone;
        } as AnyObject
    }*/
    
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
