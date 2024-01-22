//
//  ViewController.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 21/01/24.
//

import UIKit

class ContactsViewController: UIViewController {
    private var cellModels: [Contact] = []
    
    private var cellId = "ContactCellID"
    
    private let service: ContactService = ContactServiceImpl()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       title = "Contacts"
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
      
        service.grantAccess { [weak self] isGranted in
            guard isGranted else {
                // TODO: alert that shows settings
                return
            }
            
            self?.loadData()
        }
    }

    func loadData() {
        service.loadContacts { [weak self] contacts in
            self?.cellModels = contacts
            self?.tableView.reloadData()
        }
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let contact = cellModels[indexPath.row]
        cell.textLabel?.text = "\(contact.name) - \(contact.phone)"
        return cell
        
    }
    
    
}
