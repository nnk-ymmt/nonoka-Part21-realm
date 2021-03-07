//
//  Fruit.swift
//  nonoka-Part21-realm
//
//  Created by 山本ののか on 2021/02/24.
//

import Foundation
import RealmSwift

final class Fruit: Object {
    @objc dynamic var uuidString = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var isChecked = false
    @objc dynamic var createdAt = Date()

    var uuid: UUID? {
        UUID(uuidString: uuidString)
    }

    override class func primaryKey() -> String? {
        "uuidString"
    }
}
