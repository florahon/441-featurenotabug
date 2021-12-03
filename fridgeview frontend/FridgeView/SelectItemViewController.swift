//
//  SelectItemViewController.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 11/23/21.
//

import UIKit
var rowsWhichAreChecked = [NSIndexPath]()
class SelectItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct SelectedItems{
        static var selected = [Item]()
    }
    
    var categories = [Category]()
    let CellIdentifier = "Cell Identifier"

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
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
                        print(1)
                    }
                }
            }
            cur_cat = cur_cat + 1
            count = 0
        }
        SelectedItems.selected = []
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadItems()
        saveItems()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
             
           let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
           lbl.font = UIFont.systemFont(ofSize: 20)
           lbl.text = categories[section].categoryName
           view.addSubview(lbl)
           return view
         }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
         
        // Fetch Item
        let item = categories[indexPath.section].item[indexPath.row]
         
        // Configure Table View Cell
        cell.label.text = item.name
        let isRowChecked = rowsWhichAreChecked.contains(indexPath as NSIndexPath)
        cell.check.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! Cell
        // cross checking for checked rows
        cell.check.isHidden = false
        print(categories[indexPath.section].item[indexPath.row].name)
        SelectedItems.selected.append(categories[indexPath.section].item[indexPath.row])
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! Cell
        cell.check.isHidden = true
        var count = 0
        for s in SelectedItems.selected{
            if s.expr_date == categories[indexPath.section].item[indexPath.row].expr_date && s.name == categories[indexPath.section].item[indexPath.row].name &&
                s.quantity == categories[indexPath.section].item[indexPath.row].quantity{
                SelectedItems.selected.remove(at: count)
            }
            count = count + 1
        }
        // remove the indexPath from rowsWhichAreCheckedArray
        if let checkedItemIndex = rowsWhichAreChecked.firstIndex(of: indexPath as NSIndexPath){
            rowsWhichAreChecked.remove(at: checkedItemIndex)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 60
    }
         
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60
    }
    
}
