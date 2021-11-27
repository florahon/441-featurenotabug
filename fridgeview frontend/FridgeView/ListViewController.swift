//
//  ListViewController.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 10/29/21.
//

import UIKit

class Category {
   var categoryName: String?
    var item = [Item]()
     
   init(categoryName: String) {
       self.categoryName = categoryName
   }
}

class ListViewController: UITableViewController, AddItemVCDelegate, EditVCDelegate {
    
    struct Inventory{
        static var categories = [Category]()
    }
    var selection: Item?
    let CellIdentifier = "Cell Identifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        Inventory.categories.append(Category.init(categoryName: "Produce"))
        Inventory.categories.append(Category.init(categoryName: "Dairy"))
        Inventory.categories.append(Category.init(categoryName: "Protein"))
        Inventory.categories.append(Category.init(categoryName: "Other"))
            
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
        var count = 0
        for cat in Inventory.categories{
            // Fetch Index for Item
            if let index = cat.item.index(of: item) {
                    // Update Table View
                    tableView.reloadRows(at: [IndexPath(row: index, section: count)], with: .fade)
                }
            count = count + 1
        }
            // Save Items
            saveItems()
    }
    
    private func loadItems() {
            if let filePath = pathForItems(), FileManager.default.fileExists(atPath: filePath) {
                if var archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Item] {
                    for cat in Inventory.categories{
                        archivedItems = archivedItems + cat.item
                    }
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
            for cat in Inventory.categories{
                NSKeyedArchiver.archiveRootObject(cat.item, toFile: filePath)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Inventory.categories.count
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("edit")
        // Fetch Item
        let item = Inventory.categories[indexPath.section].item[indexPath.row]
         
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
            Inventory.categories[indexPath.section].item.remove(at: indexPath.row)
             
            // Update Table View
            tableView.deleteRows(at: [indexPath], with: .right)
             
            // Save Changes
            saveItems()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
             
           let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
           lbl.font = UIFont.systemFont(ofSize: 20)
           lbl.text = Inventory.categories[section].categoryName
           view.addSubview(lbl)
           return view
         }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Inventory.categories[section].item.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
         
        // Fetch Item
        let item = Inventory.categories[indexPath.section].item[indexPath.row]
         
        // Configure Table View Cell
        cell.textLabel?.text = item.name
        cell.accessoryType = .detailDisclosureButton
         
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40
    }
         
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40
    }
    
    func controller(controller: AddItemViewController, didSaveItemWithName name: String, andQuantity quantity: Int, andExpr_Date expr_date: String, andCategory category: String) {
        // Create Item
        let item = Item(name: name, quantity: quantity, expr_date: expr_date)
        var cur_cat = 0
        var count = 0
        for cat in Inventory.categories{
            if cat.categoryName == category{
                (cat.item).append(item)
                cur_cat = count
            }
            count = count + 1
        }
        
        tableView.insertRows(at: [IndexPath(row: (Inventory.categories[cur_cat].item.count - 1), section: cur_cat)], with: .automatic)
        
        saveItems()
    }

    /*
     let selectItemViewController =
     self.storyboard!.instantiateViewController(withIdentifier: "SelectItemViewController")
     as! SelectItemViewController

         // pass the relevant data to the new sub-ViewController
     var cur_cat2 = 0
     var count2 = 0
     for cat in selectItemViewController.categories{
         if cat.categoryName == category{
             (cat.item).append(item)
             cur_cat2 = count2
         }
         count2 = count2 + 1
     }
     
     selectItemViewController.tableView.insertRows(at: [IndexPath(row: (selectItemViewController.categories[cur_cat2].item.count - 1), section: cur_cat2)], with: .automatic)
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
