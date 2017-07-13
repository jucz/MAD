//
//  SweetsTableViewController.swift
//  
//
//  Created by Studium on 12.07.17.
//
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SweetsTableViewController: UITableViewController {
    
    var dbRef: DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("sweet-items")

    }
    
    @IBAction func addSweet(sender: Any) {
        let sweetAlert = UIAlertController(title: "New Sweet", message: "Enter your Sweet", preferredStyle: .alert)
        sweetAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "Your sweet"
        }
        sweetAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action: UIAlertAction) in
            if let sweetContent = sweetAlert.textFields?.first?.text {
                let sweet = Sweet(content: sweetContent, addedByUser: "JulianCzech")
                
                let sweetRef = self.dbRef.child(sweetContent.lowercased())
                
                sweetRef.setValue(sweet.toAny())
            }
        }))
        
        self.present(sweetAlert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...

        return cell
    }
    

}
