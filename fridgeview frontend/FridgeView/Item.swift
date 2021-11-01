//
//  Item.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 10/29/21.
//

import UIKit

class Item: NSObject, NSCoding {
    var uuid: String = NSUUID().uuidString
    var name: String = ""
    var quantity: Int = 0
    var expr_date: String = ""
    
    init(name: String, quantity: Int, expr_date: String) {
        super.init()
        
        self.name = name
        self.quantity = quantity
        self.expr_date = expr_date
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(uuid, forKey: "uuid")
        coder.encode(name, forKey: "name")
        coder.encode(quantity, forKey: "quantity")
        coder.encode(expr_date, forKey: "expr_date")
    }
    
    required init?(coder decoder: NSCoder) {
        super.init()
        
        if let archivedUuid = decoder.decodeObject(forKey: "uuid") as? String {
            uuid = archivedUuid
        }
        
        if let archivedName = decoder.decodeObject(forKey: "name") as? String {
            name = archivedName
        }
        
        quantity = decoder.decodeInteger(forKey: "quantity")
        if let archivedExpr_Date = decoder.decodeObject(forKey: "expr_date") as? String {
            expr_date = archivedExpr_Date
        }
    }
}
