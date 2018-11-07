//
//  TodoItem.swift
//  ZenDo
//
//  Created by cory.roy on 2018-11-05.
//  Copyright © 2018 cory.roy. All rights reserved.
//

import Foundation

class TodoItem : Codable {
    var item: String
    var done: Bool = false
    
    init(_ newItem: String) {
        item = newItem
    }
}
