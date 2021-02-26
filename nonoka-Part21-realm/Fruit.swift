//
//  Fruit.swift
//  nonoka-Part21-realm
//
//  Created by 山本ののか on 2021/02/24.
//

import Foundation
import RealmSwift

class Fruit: Object {
    dynamic var name = ""
    dynamic var isChecked = false
    dynamic var createdAt = Date()
}
