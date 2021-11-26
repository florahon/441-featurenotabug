//
//  SelectItemViewController.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 11/23/21.
//

import UIKit

class SelectItemViewController: UITableViewController {
    
    var categories = [Category]()
    let CellIdentifier = "Cell Identifier"
    var selected = [Category]()


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        categories.append(Category.init(categoryName: "Produce"))
        categories.append(Category.init(categoryName: "Dairy"))
        categories.append(Category.init(categoryName: "Protein"))
        categories.append(Category.init(categoryName: "Other"))
        
        // print(ListViewController.Inventory.categories.count)
        // print("loading")
        var cur_cat = 0
        var count = 0
        for select_cat in categories{
            // print("select item catergory")
            for cat in ListViewController.Inventory.categories{
                // print("list view category")
                for i in cat.item{
                    if cat.categoryName == select_cat.categoryName{
                        (select_cat.item).append(i)
                        count = count + 1
                        tableView.insertRows(at: [IndexPath(row: (categories[cur_cat].item.count - 1), section: cur_cat)], with: .automatic)
                        print(1)
                    }
                }
            }
            cur_cat = cur_cat + 1
            count = 0
        }
            
        // navigationItem.rightBarButtonItems = [add, edit]
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Load Items
        loadItems()
    }
    
    private func loadItems() {
            if let filePath = pathForItems(), FileManager.default.fileExists(atPath: filePath) {
                if var archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Item] {
                    for cat in categories{
                        archivedItems = archivedItems + cat.item
                    }
                }
            }
        }
    
    private func saveItems() {
        if let filePath = pathForItems() {
            for cat in categories{
                NSKeyedArchiver.archiveRootObject(cat.item, toFile: filePath)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadItems()
        saveItems()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
             
           let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
           lbl.font = UIFont.systemFont(ofSize: 20)
           lbl.text = categories[section].categoryName
           view.addSubview(lbl)
           return view
         }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].item.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
         
        // Fetch Item
        let item = categories[indexPath.section].item[indexPath.row]
         
        // Configure Table View Cell
        cell.textLabel?.text = item.name
        cell.accessoryType = .
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
        cell.accessoryType = .checkmark
        
        return cell
    }

    func resetChecks() {
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) {
                    cell.accessoryType = .none
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40
    }
         
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40
    }
    
}
