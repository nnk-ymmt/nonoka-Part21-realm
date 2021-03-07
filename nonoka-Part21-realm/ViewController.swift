//
//  ViewController.swift
//  nonoka-Part21-realm
//
//  Created by 山本ののか on 2021/02/24.
//

import UIKit
import RealmSwift

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(TableViewCell.loadNib(), forCellReuseIdentifier: TableViewCell.reuseIdentifier)
            tableView.isHidden = true
        }
    }

    private(set) var editIndexPath: IndexPath?
    private let repository = FruitRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
        tableView.isHidden = false

        repository.observe(notifier: { [weak self] in
            self?.tableView.reloadData()
        })
    }

    @IBAction func cancel(segue: UIStoryboardSegue) { }

    @IBAction func save(segue: UIStoryboardSegue) {
        guard let inputVC = segue.source as? InputViewController,
              let newFruit = inputVC.output else {
            return
        }
        repository.append(fruit: newFruit)
    }

    @IBAction func edit(segue: UIStoryboardSegue) {
        guard let inputVC = segue.source as? InputViewController,
              let newName = inputVC.editName,
              let uuid = inputVC.editUUID else {
            return
        }
        repository.update(uuid: uuid, name: newName)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = (segue.destination as? UINavigationController)?.topViewController as? InputViewController {
            switch segue.identifier ?? "" {
            case "input":
                nextVC.mode = .input
            case "edit":
                guard let editIndexPath = editIndexPath else { return }
                let fruit = repository.load()[editIndexPath.row]
                nextVC.mode = .edit(fruit)
            default:
                break
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repository.load().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        let fruit = repository.load()[indexPath.row]
        cell.configure(fruit: fruit)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fruit = repository.load()[indexPath.row]
        guard let uuid = fruit.uuid else { return }
        repository.toggleCheck(uuid: uuid)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        editIndexPath = indexPath
        performSegue(withIdentifier: "edit", sender: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let fruit = repository.load()[indexPath.row]
        guard let uuid = fruit.uuid else { return }
        repository.remove(uuid: uuid)
    }
}
