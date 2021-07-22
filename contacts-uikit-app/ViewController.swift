//
//  ViewController.swift
//  contacts-uikit-app
//
//  Created by Илья Груздев on 22.07.2021.
//

import Contacts
import ContactsUI
import UIKit


struct Person {
    let name: String
    let id: String
    let number: String
    let source: CNContact
}

class ViewController: UIViewController, UITableViewDataSource ,CNContactPickerDelegate, UITableViewDelegate{
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    var models = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        table.frame = view.bounds
        table.dataSource = self
        table.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd))
    }

    @objc func didTapAdd() {
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let number = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
        let name = contact.familyName + " " + contact.givenName + " " + contact.middleName + " / " + number
        let identifier = contact.identifier
        let model = Person(name: name,
                           id: identifier,
                           number: number,
                           source: contact
        )
        models.append(model)
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: "tel://\(models[indexPath.row].number)") else {
            return
        }
        UIApplication.shared.open(url)
    }

}

