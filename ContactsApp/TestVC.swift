//
//  TestVC.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 23/01/24.
//

import UIKit
import SnapKit

class Person {
    var name: String
    var contactMethod: String
    
    init(name: String, contactMethod: String) {
        self.name = name
        self.contactMethod = contactMethod
    }
}

class CustomCell: UITableViewCell {
    let nameLabel = UILabel()
       let contactMethodLabel = UILabel()

       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)

           setupUI()
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       func setupUI() {
           addSubview(nameLabel)
           addSubview(contactMethodLabel)

           nameLabel.snp.makeConstraints { make in
               make.top.equalToSuperview().offset(8)
               make.leading.equalToSuperview().offset(16)
               make.trailing.equalToSuperview().offset(-16)
           }

           contactMethodLabel.snp.makeConstraints { make in
               make.top.equalTo(nameLabel.snp.bottom).offset(4)
               make.leading.equalToSuperview().offset(16)
               make.trailing.equalToSuperview().offset(-16)
               make.bottom.equalToSuperview().offset(-8)
           }

           nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
           contactMethodLabel.font = UIFont.systemFont(ofSize: 14)
       }

       func configure(with person: Person) {
           nameLabel.text = person.name
           contactMethodLabel.text = "Contact: \(person.contactMethod)"
       }
}
import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var people: [Person] = [
        Person(name: "John", contactMethod: "Email"),
        Person(name: "Jane", contactMethod: "Telegram"),
        Person(name: "Bob", contactMethod: "Telegram"),
        // Add more people as needed
    ]
    
    var showFilteredPeopleCount: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }

    var filteredPeople: [Person] {
        if showFilteredPeopleCount {
            return people.filter { $0.contactMethod == "Telegram" }
        } else {
            return people
        }
    }

    let tableView = UITableView()
    let sortButton = UIButton()
    let countLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(sortButton)
        view.addSubview(countLabel)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        sortButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }

        countLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(sortButton.snp.bottom).offset(8)
        }

        sortButton.setTitle("Sort", for: .normal)
        sortButton.setTitleColor(.blue, for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        
        // Initially, show all people
        tableView.reloadData()
    }

    @objc func sortButtonTapped() {
        showFilteredPeopleCount.toggle()
        updateCountLabel()
    }

    func updateCountLabel() {
        if showFilteredPeopleCount {
            countLabel.text = "Filtered People Count: \(filteredPeople.count)"
        } else {
            countLabel.text = ""
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPeople.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let person = filteredPeople[indexPath.row]
        cell.configure(with: person)
        return cell
    }
}
