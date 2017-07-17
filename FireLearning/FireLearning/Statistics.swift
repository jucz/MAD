
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
    
    //Setter
    //not necessary yet
    
    
    //Getter
    public func getResultComplete() -> Int {
        return self.resultComplete
    }
    
    public func getResultDone() -> Int {
        return self.resultDone
    }
    
    
}
