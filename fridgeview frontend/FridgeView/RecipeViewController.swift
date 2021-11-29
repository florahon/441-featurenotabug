//
//  RecipeViewController.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 11/28/21.
//
import UIKit

class RecipeViewController: UITableViewController{
    
    let CellIdentifier = "Cell Identifier"
    var recipes = ["example1", "example2"]
    var selected_items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        print("test")
        print(SelectItemViewController.SelectedItems.selected.count)
        for s_item in SelectItemViewController.SelectedItems.selected{
            print(s_item)
        }
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Load Items
        loadItems()
    }
    
    private func loadItems() {
            if let filePath = pathForItems(), FileManager.default.fileExists(atPath: filePath) {
                if var archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [String] {
                    archivedItems = archivedItems + recipes
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
            for r in recipes{
                NSKeyedArchiver.archiveRootObject(r, toFile: filePath)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
         
        // Fetch Item
        let item = recipes[indexPath.row]
         
        // Configure Table View Cell
        cell.textLabel?.text = item
         
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40
    }
         
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40
    }

}
