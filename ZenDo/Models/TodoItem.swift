//
//  TodoItem.swift
//  ZenDo
//
//  Created by cory.roy on 2018-11-10.
//  Copyright © 2018 cory.roy. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
