//
//  FruitUseCase.swift
//  nonoka-Part21-realm
//
//  Created by 山本ののか on 2021/02/28.
//

import Foundation
import RealmSwift

///  配列の管理をせず、作成・削除・更新などの要求を処理するのみ
/// リポジトリが配列の管理をしてしまうと、複数のリポジトリを複数箇所で並列して使用した場合、
/// 配列の中身が同期されないという問題が起こる
/// RealmのNotificationを使って、変更に応じて自動リロード

final class FruitRepository {

//    private(set) var fruits: [Fruit] = []
    private let realm = try! Realm()
    private var notificationToken: NotificationToken?

//    init() {
//        fruits = load() ?? []
//    }

    func observe(notifier: @escaping () -> Void) {
        notificationToken = realm
            .objects(Fruit.self)
            .sorted(byKeyPath: "createdAt")
            .observe { _ in
                notifier()
            }
    }

//    func load() -> [Fruit]? {
//        let fruit = realm.objects(Fruit.self).sorted(byKeyPath: "createdAt")
//        var fruitArray: [Fruit] = []
//        fruitArray.append(contentsOf: fruit)
//        return fruitArray
//    }

    func load() -> [Fruit] {
        let fruits = realm.objects(Fruit.self).sorted(byKeyPath: "createdAt")
        return Array<Fruit>(fruits)
    }

    func append(fruit: Fruit) {
        try! realm.write {
            realm.add(fruit)
        }
//        fruits.append(fruit)
    }

//    func update(index: Int, fruit: String) {
//        try! realm.write() {
//            fruits[index].name = fruit
//        }
//    }

    func update(uuid: UUID, name: String) {
        guard let fruit = realm.object(ofType: Fruit.self, forPrimaryKey: uuid.uuidString) else { return }
        try! realm.write() {
            fruit.name = name
        }
    }

//    func toggleCheck(index: Int) {
//        try! realm.write() {
//            fruits[index].isChecked.toggle()
//        }
//    }

    func toggleCheck(uuid: UUID) {
        guard let fruit = realm.object(ofType: Fruit.self, forPrimaryKey: uuid.uuidString) else { return }
        try! realm.write() {
            fruit.isChecked.toggle()
        }
    }

//    func remove(index: Int) {
//        try! realm.write() {
//            realm.delete(fruits[index])
//        }
//        fruits.remove(at: index)
//    }

    func remove(uuid: UUID) {
        guard let fruit = realm.object(ofType: Fruit.self, forPrimaryKey: uuid.uuidString) else { return }
        try! realm.write() {
            realm.delete(fruit)
        }
    }
}
