//
//  RecipeCell.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 11/30/21.
//

import UIKit

class RecipeCell: UITableViewCell{
    
    @IBOutlet var link: UIButton!
    var urlLink = URL(string: "http://google.com")
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didTap(sender: AnyObject) {
        UIApplication.shared.open(urlLink!)
    }
}
