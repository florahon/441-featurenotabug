//
//  EditViewController.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 10/29/21.
//

import UIKit
 
protocol EditVCDelegate {
    func controller(controller: EditViewController, didUpdateItem item: Item)
}
 
class EditViewController: UIViewController {
 
    @IBOutlet var nTextField: UITextField!
    
    @IBOutlet var quantityTextField: UITextField!
    
    @IBOutlet var expr_dateTextField: UITextField!
    
    @IBOutlet weak var btnSelectCategory: UIButton!
    let transparentView = UIView()
        let tableView = UITableView()
        
        var selectedButton = UIButton()
        
        var dataSource = [String]()
    var category = ""
    var clicked = 0
     
    var item: Item!
     
    var delegate: EditVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
                tableView.dataSource = self
                tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        // Create Save Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditViewController.save(sender:)))
        
        nTextField.text = item.name
        quantityTextField.text = "\(item.quantity)"
        expr_dateTextField.text = item.expr_date
    }
    
    
     
    @objc func save(sender: UIBarButtonItem) {
        if let name = nTextField.text, let quantityAsString = quantityTextField.text, let quantity = Int(quantityAsString), let expr_date = expr_dateTextField.text {
            // Update Item
            item.name = name
            item.quantity = quantity
            item.expr_date = expr_date
            if (selectedButton.currentTitle == "Produce" || selectedButton.currentTitle == "Dairy" || selectedButton.currentTitle == "Protein" ||
                selectedButton.currentTitle == "Other") {
                category = selectedButton.currentTitle!
                item.category = category
            }
             
            // Notify Delegate
            delegate?.controller(controller: self, didUpdateItem: item)
             
            // Pop View Controller
            navigationController?.popViewController(animated: true)
        }
    }
    
    func addTransparentView(frames: CGRect) {
            let window = UIApplication.shared.keyWindow
            transparentView.frame = window?.frame ?? self.view.frame
            self.view.addSubview(transparentView)
            
            tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            self.view.addSubview(tableView)
            tableView.layer.cornerRadius = 5
            
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            tableView.reloadData()
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
            transparentView.addGestureRecognizer(tapgesture)
            transparentView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.transparentView.alpha = 0.5
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
            }, completion: nil)
        }
        
        @objc func removeTransparentView() {
            let frames = selectedButton.frame
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.transparentView.alpha = 0
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            }, completion: nil)
        }

    @IBAction func onClickSelectCategory(_ sender: Any) {
            clicked = 1
            dataSource = ["Produce", "Dairy", "Protein", "Other"]
            selectedButton = btnSelectCategory
            print("testing before the if statement")
            addTransparentView(frames: btnSelectCategory.frame)
        
        }
}
extension EditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}
