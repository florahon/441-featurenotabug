//
//  ListViewController.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 10/29/21.
//

import UIKit

class ListViewController: UITableViewController, AddItemVCDelegate, EditVCDelegate {
    

    var items = [Item]()
    var selection: Item?
    let CellIdentifier = "Cell Identifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
            
        // Create Add Button
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ListViewController.addItem(sender:)))
        
        //edit button
        let edit = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(ListViewController.editItems(sender:)))
        
        navigationItem.rightBarButtonItems = [add, edit]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemViewController" {
            if let navigationController = segue.destination as? UINavigationController,
               let addItemViewController = navigationController.viewControllers.first as? AddItemViewController {
                addItemViewController.delegate = self
            }
        } else if segue.identifier == "EditViewController" {
            if let editViewController = segue.destination as? EditViewController, let item = selection {
                editViewController.delegate = self
                editViewController.item = item
            }
        }
    }
    
    @objc func addItem(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddItemViewController", sender: self)
    }
    
    @objc func editItems(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Load Items
        loadItems()
    }
    
    func controller(controller: EditViewController, didUpdateItem item: Item) {
        // Fetch Index for Item
            if let index = items.index(of: item) {
                // Update Table View
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
             
            // Save Items
            saveItems()
    }
    
    private func loadItems() {
        if let filePath = pathForItems(), FileManager.default.fileExists(atPath: filePath) {
            if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Item] {
                items = archivedItems
            }
        }
    }
    
    private func pathForItems() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = paths.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.appendingPathComponent("items.plist")?.path
        }
        
        return nil
    }
    
    private func saveItems() {
        if let filePath = pathForItems() {
            NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
         
        // Fetch Item
        let item = items[indexPath.row]
         
        // Configure Table View Cell
        cell.textLabel?.text = item.name
        cell.accessoryType = .detailDisclosureButton
         
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // Fetch Item
        let item = items[indexPath.row]
         
        // Update Selection
        selection = item
         
        // Perform Segue
        performSegue(withIdentifier: "EditViewController", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete Item from Items
            items.remove(at: indexPath.row)
             
            // Update Table View
            tableView.deleteRows(at: [indexPath], with: .right)
             
            // Save Changes
            saveItems()
        }
    }
    
    func controller(controller: AddItemViewController, didSaveItemWithName name: String, andQuantity quantity: Int, andExpr_Date expr_date: String) {
        // Create Item
        let item = Item(name: name, quantity: quantity, expr_date: expr_date)
        
        // Add Item to Items
        items.append(item)
        
        tableView.insertRows(at: [IndexPath(row: (items.count - 1), section: 0)], with: .automatic)
        
        saveItems()
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
