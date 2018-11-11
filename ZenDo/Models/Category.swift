//
//  Category.swift
//  ZenDo
//
//  Created by cory.roy on 2018-11-10.
//  Copyright © 2018 cory.roy. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<TodoItem>()
}
