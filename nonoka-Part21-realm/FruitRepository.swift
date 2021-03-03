//
//  FruitUseCase.swift
//  nonoka-Part21-realm
//
//  Created by 山本ののか on 2021/02/28.
//

import Foundation
import RealmSwift

final class FruitRepository {

    private(set) var fruits: [Fruit] = []
    private let realm = try! Realm()

    init() {
        fruits = load() ?? []
    }

    func load() -> [Fruit]? {
        let fruit = realm.objects(Fruit.self).sorted(byKeyPath: "createdAt")
        var fruitArray: [Fruit] = []
        fruitArray.append(contentsOf: fruit)
        return fruitArray
    }

    func append(fruit: Fruit) {
        try! realm.write {
            realm.add(fruit)
        }
        fruits.append(fruit)
    }

    func update(index: Int, fruit: String) {
        try! realm.write() {
            fruits[index].name = fruit
        }
    }

    func toggleCheck(index: Int) {
        try! realm.write() {
            fruits[index].isChecked.toggle()
        }
    }

    func remove(index: Int) {
        try! realm.write() {
            realm.delete(fruits[index])
        }
        fruits.remove(at: index)
    }
}
