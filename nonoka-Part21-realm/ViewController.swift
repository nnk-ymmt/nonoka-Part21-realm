//
//  ViewController.swift
//  nonoka-Part21-realm
//
//  Created by 山本ののか on 2021/02/24.
//

import UIKit
import RealmSwift

final class ViewController: UIViewController {

    static let entityName = "Fruit"
    var results: Results<Fruit> = Realm().objects(Fruit.self).sorted(byKeyPath: "createdAt")
    var editIndexPath: IndexPath?

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(TableViewCell.loadNib(), forCellReuseIdentifier: TableViewCell.reuseIdentifier)
            tableView.isHidden = true
        }
    }

    private(set) var editIndexPath: IndexPath?
    private let useCase = FruitsUseCase()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
        tableView.isHidden = false
    }

    @IBAction func cancel(segue: UIStoryboardSegue) { }

    @IBAction func save(segue: UIStoryboardSegue) {
        guard let inputVC = segue.source as? InputViewController,
              let newFruit = inputVC.output else {
            return
        }
        useCase.append(fruit: newFruit)
        tableView.reloadData()
    }

    @IBAction func edit(segue: UIStoryboardSegue) {
        guard let inputVC = segue.source as? InputViewController,
              let fruit = inputVC.editName,
              let editIndexPath = editIndexPath else {
            return
        }
        useCase.replace(index: editIndexPath.row, fruit: fruit)
//        tableView.reloadRows(at: [editIndexPath], with: .automatic)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = (segue.destination as? UINavigationController)?.topViewController as? InputViewController {
            switch segue.identifier ?? "" {
            case "input":
                nextVC.mode = .input
            case "edit":
                guard let editIndexPath = editIndexPath else { return }
                nextVC.mode = .edit(useCase.fruits[editIndexPath.row])
            default:
                break
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}
