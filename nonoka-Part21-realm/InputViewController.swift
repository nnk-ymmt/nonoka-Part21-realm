//
//  InputViewController.swift
//  nonoka-Part21-realm
//
//  Created by 山本ののか on 2021/02/24.
//

import UIKit

final class InputViewController: UIViewController {

    enum Mode {
        case input
        case edit(Fruit)
    }

    @IBOutlet private weak var textField: UITextField!

    var mode: Mode?
    private(set) var output: Fruit?
    private(set) var editName: String?
    private let repository = FruitRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mode = mode else {
            fatalError("mode is nil.")
        }

        textField.text = {
            switch mode {
            case .input:
                return ""
            case let .edit(fruit):
                return fruit.name
            }
        }()
    }

    @IBAction private func saveAction(_ sender: Any) {
        guard let mode = mode else { return }

        switch mode {
        case .input:
            let newFruit = Fruit()
            newFruit.name = textField.text ?? ""
            newFruit.isChecked = false
            newFruit.createdAt = Date()
            output = newFruit
        case .edit:
            editName = textField.text ?? ""
        }

        performSegue(
            withIdentifier: {
                switch mode {
                case .edit:
                    return "edit"
                case .input:
                    return "save"
                }
            }(),
            sender: sender
        )
    }
}
