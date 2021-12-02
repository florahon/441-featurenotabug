//
//  CameraItemViewController.swift
//  FridgeView
//
//  Created by Akash Agrawal Bejarano on 11/30/21.
//

import UIKit
import Foundation

class CameraItemViewController: UITableViewController, UINavigationControllerDelegate{
    
    var items = [Item]()
    let CellIdentifier = "Cell Identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        tableView.delegate = self
        
        print("count: ", AddItemViewController.ScannedItems.scanned.count)
        for i in AddItemViewController.ScannedItems.scanned{
            print("scanned item: " + i.name)
            items.append(i)
            print(items)
        }
        self.tableView.reloadData()
        
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CameraItemViewController.saveItems(sender:)))
        
        navigationItem.rightBarButtonItems = [save]
    }
    
    @objc func saveItems(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ListViewController", sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
        // Fetch Item
        let item = items[indexPath.row]
        

        //print("item in table view: " + item)
        //print("recipe: " + usedUrls[indexPath.row])
         
        // Configure Table View Cell
        cell.textLabel?.text = item.name
         
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40
    }
         
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40
    }
}
