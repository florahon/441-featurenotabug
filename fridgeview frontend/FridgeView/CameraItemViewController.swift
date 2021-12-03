//
//  CameraItemViewController.swift
//  FridgeView
//
//  Created by Akash Agrawal Bejarano on 11/30/21.
//

import UIKit

protocol CameraItemVCDelegate {
    func controller(controller: CameraItemViewController, didUpdateItems items: [Item])
}

class CameraItemViewController: UITableViewController, EditVCDelegate {
    
    
    var items = [Item]()
    var selection: Item?
    let CellIdentifier = "Cell Identifier"
    var delegate: CameraItemVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        print("count: ", AddItemViewController.ScannedItems.scanned.count)
        for i in AddItemViewController.ScannedItems.scanned{
            print("scanned item: " + i.name)
            items.append(i)
        }
        
        let edit = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(CameraItemViewController.editItems(sender:)))
        
        navigationItem.leftBarButtonItem = edit
    }
    
    
    @IBAction func sendItems(sender: UIBarButtonItem) {
        
        // Notify Delegate
        delegate?.controller(controller: self, didUpdateItems: items)
         print("about to segue")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        // Pop View Controller
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editItems(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditVC" {
            print("gets to here")
            if let editViewController = segue.destination as? EditViewController, let item = selection {
                print("gets in here")
                editViewController.delegate = self
                editViewController.item = item
            }
        }
    }
    
    func controller(controller: EditViewController, didUpdateItem item: Item) {
        if let index = items.index(of: item) {
                // Update Table View
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
             
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete Item from Items
            items.remove(at: indexPath.row)
             
            // Update Table View
            tableView.deleteRows(at: [indexPath], with: .right)
             
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("edit")
        // Fetch Item
        let item = items[indexPath.row]
         
        // Update Selection
        selection = item
         
        // Perform Segue
        performSegue(withIdentifier: "EditVC", sender: self)
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40
    }
         
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40
    }
}
