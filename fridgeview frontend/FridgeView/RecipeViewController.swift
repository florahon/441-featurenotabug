//
//  RecipeViewController.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 11/28/21.
//
import UIKit
import Foundation
import Alamofire

class RecipeViewController: UITableViewController{
    
    var recipes = [String]()
    var urls: [String] = []
    let CellIdentifier = "Cell Identifier"
    var recipe_string = ""
    let serverUrl = "https://3.131.128.223"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        // Do any additional setup after loading the view.
        var count = 0
        print(SelectItemViewController.SelectedItems.selected.count)
        for s_item in SelectItemViewController.SelectedItems.selected{
            if count == 0 {
                recipe_string = s_item.name
            }
            else{
                recipe_string = recipe_string + ", " + s_item.name
            }
            print(s_item)
            count = count + 1
        }
        print(recipe_string)
        let jsonObj = ["ingredients": recipe_string]
            guard let apiUrl = URL(string: serverUrl+"/getrecipes/") else {
                print("getRecipes: Bad URL")
                return
            }
            
        let group = DispatchGroup()
            group.enter()
        DispatchQueue.global().async {
            AF.request(apiUrl, method: .get, parameters: jsonObj, encoding: URLEncoding.default).responseJSON { response in
                if case let .success(recipe) = response.result {
                    if let dictionary = recipe as? [String: Any] {
                        for (key, value) in dictionary {
                                
                            print(key)
                            print(value)
                            print("-------")
                            if let dict2 = value as? [String: Any]{
                                for (key, value) in dict2 {
                                    print("dict2")
                                    print(key)
                                    print(value)
                                    print("-------")
                                    let v = value as! String
                                    var v2 = ""
                                    v2 = v
                                    if ((v.starts(with: "http")) == true){
                                        print("urls")
                                        print("v2: " + v2)
                                        self.urls.append(v2)
                                    }
                                    else{
                                        print("recipes")
                                        print("v2: " + v2)
                                        self.recipes.append(v2)
                                    }
                                }
                            }
                            }
                    }
                    }
                }
                group.leave()
            }
        
        
        group.notify(queue: .main) {
            print(self.recipes.count)
            print("RECIPES:")
            for rec in self.recipes{
                print(rec)
            }
            }
        let secondsToDelay = 12.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
           print("This message is delayed")
            print(self.recipes.count)
            print("RECIPES:")
            for rec in self.recipes{
                print(rec)
            }
            self.tableView.reloadData()
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
        print("item in table view: " + item)
         
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
