//
//  FruitUseCase.swift
//  nonoka-Part21-realm
//
//  Created by 山本ののか on 2021/02/28.
//

import Foundation
import RealmSwift

final class FruitRepository {

    private let realm = try! Realm()

    private var notificationToken: NotificationToken?

    func observe(notifier: @escaping () -> Void) {
        notificationToken = realm
            .objects(Fruit.self)
            .sorted(byKeyPath: "createdAt")
            .observe { _ in
                notifier()
            }
    }

    func load() -> [Fruit] {
        let fruits = realm.objects(Fruit.self).sorted(byKeyPath: "createdAt")
        return Array<Fruit>(fruits)
    }

    func append(fruit: Fruit) {
        try! realm.write {
            realm.add(fruit)
        }
    }

    func update(uuid: UUID, name: String) {
        guard let fruit = realm.object(ofType: Fruit.self, forPrimaryKey: uuid.uuidString) else { return }
        try! realm.write() {
            fruit.name = name
        }
    }

    func toggleCheck(uuid: UUID) {
        guard let fruit = realm.object(ofType: Fruit.self, forPrimaryKey: uuid.uuidString) else { return }
        try! realm.write() {
            fruit.isChecked.toggle()
        }
    }

    func remove(uuid: UUID) {
        guard let fruit = realm.object(ofType: Fruit.self, forPrimaryKey: uuid.uuidString) else { return }
        try! realm.write() {
            realm.delete(fruit)
        }
    }
}
