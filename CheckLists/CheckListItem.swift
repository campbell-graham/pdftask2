//
//  CheckListItem.swift
//  CheckLists
//
//  Created by Campbell Graham on 5/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import Foundation

class CheckListItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
}
