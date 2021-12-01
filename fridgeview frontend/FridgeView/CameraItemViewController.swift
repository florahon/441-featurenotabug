//
//  CameraItemViewController.swift
//  FridgeView
//
//  Created by Akash Agrawal Bejarano on 11/30/21.
//

import UIKit
import Foundation

class CameraItemViewController: UITableViewController{
    
    var items = ["example2 CameraItem"]
    let CellIdentifier = "Cell Identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
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
