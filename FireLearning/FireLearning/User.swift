

import Foundation
import FirebaseAuth

struct User {
  
    let email: String
    let firstname: String
    let lastname: String
    var exercisesOwned = [Int:String]()
    
  
    /*init(authData: FIRUser) {
     uid = authData.uid
     email = authData.email!
     }*/
  
    init(email: String, firstname: String, lastname: String) {
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
    }
  
}
