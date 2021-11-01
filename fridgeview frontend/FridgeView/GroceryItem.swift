//
//  GroceryItem.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 10/31/21.
//

import UIKit

class GroceryItem: NSObject, NSCoding {
    var uuid: String = NSUUID().uuidString
    var name: String = ""
    var quantity: Int = 0
    
    init(name: String, quantity: Int) {
        super.init()
        
        self.name = name
        self.quantity = quantity
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(uuid, forKey: "uuid")
        coder.encode(name, forKey: "name")
        coder.encode(quantity, forKey: "quantity")
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
    }
}
