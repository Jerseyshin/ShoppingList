//
//  CommidityTableViewController.swift
//  ShoppingListJW
//
//  Created by njuios on 2020/11/11.
//

import UIKit
import os.log


class CommidityTableViewController: UITableViewController {
    //MARK: Properties
     
    var commidities = [Commidity]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved commidities, otherwise load sample data.
        if let savedCommidities = loadCommidities() {
            commidities += savedCommidities
        }
        else {
            // Load the sample data.
            loadSampleCommidities()
        }
        
    }
    
    //MARK: Actions:
    @IBAction func unwindToCommidityList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CommidityViewController, let commidity = sourceViewController.commidity {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                commidities[selectedIndexPath.row] = commidity
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // Add a new commidity.
                let newIndexPath = IndexPath(row: commidities.count, section: 0)
                    
                commidities.append(commidity)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the commidities.
            saveCommidities()
        }
    }
    
    //MARK: Private Methods:
    private func loadSampleCommidities() {
        let photo1 = UIImage(named: "clothes")
        let photo2 = UIImage(named: "laptop")
        let photo3 = UIImage(named: "scarf")
        
        guard let commidity1 = Commidity(name: "Clothes", photo: photo1, rating: 4, wish: "I like this suit!") else {
            fatalError("Unable to instantiate commidity1")
        }
         
        guard let commidity2 = Commidity(name: "Laptop", photo: photo2, rating: 5, wish: "I need a laptop!") else {
            fatalError("Unable to instantiate commidity2")
        }
         
        guard let commidity3 = Commidity(name: "Scarf", photo: photo3, rating: 3, wish: "I feel cold!") else {
            fatalError("Unable to instantiate commidity2")
        }
        
        commidities += [commidity1, commidity2, commidity3]
        
        
    }
    
    private func saveCommidities() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(commidities, toFile: Commidity.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
        
    }
    
    private func loadCommidities() -> [Commidity]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Commidity.ArchiveURL.path) as? [Commidity]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commidities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CommidityTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CommidityTableViewCell else{
            fatalError("The dequeued cell is not an instance of CommidityTableViewCell.")
        }

        // Fetches the appropriate commidity for the data source layout.
        let commidity = commidities[indexPath.row]
        
        cell.nameLabel.text = commidity.name
        cell.photoImageView.image = commidity.photo
        cell.ratingControl.rating = commidity.rating

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            commidities.remove(at: indexPath.row)
            saveCommidities()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
        guard let commidityDetailViewController = segue.destination as? CommidityViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
         
        guard let selectedCommidityCell = sender as? CommidityTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
         
        guard let indexPath = tableView.indexPath(for: selectedCommidityCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
         
        let selectedCommidity = commidities[indexPath.row]
        commidityDetailViewController.commidity = selectedCommidity
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

}
