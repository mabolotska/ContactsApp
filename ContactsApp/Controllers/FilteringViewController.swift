//
//  FilteringViewController.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 24/01/24.
//

import UIKit

class FilteringViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
        let data = ["By name A-Z", "By name Z-A", "By surname A-Z", "By surname Z-A"]
        var selectedRows: Set<Int> = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            view.addSubview(tableView)
            tableView.register(CheckboxTableViewCell.self, forCellReuseIdentifier: "CheckboxCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        }

        // MARK: - UITableViewDataSource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxCell", for: indexPath) as? CheckboxTableViewCell else {
                return UITableViewCell()
            }

            cell.titleLabel.text = data[indexPath.row]
            cell.checkboxButton.isSelected = selectedRows.contains(indexPath.row)
            cell.checkboxButton.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)

            return cell
        }

        // MARK: - UITableViewDelegate

      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            toggleSelection(for: indexPath)
        }

        // MARK: - Checkbox Handling

        @objc func checkboxTapped(_ sender: UIButton) {
            guard let cell = sender.superview as? CheckboxTableViewCell, let indexPath = tableView.indexPath(for: cell) else {
                return
            }

            toggleSelection(for: indexPath)
        }

        func toggleSelection(for indexPath: IndexPath) {
            if selectedRows.contains(indexPath.row) {
                selectedRows.remove(indexPath.row)
            } else {
                selectedRows.insert(indexPath.row)
            }

            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }



    class CheckboxTableViewCell: UITableViewCell {

        let checkboxButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: "unchecked"), for: .normal)
            button.setImage(UIImage(named: "checked"), for: .selected)
            return button
        }()

        let titleLabel: UILabel = {
            let label = UILabel()
            return label
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            contentView.addSubview(checkboxButton)
            contentView.addSubview(titleLabel)

            checkboxButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(30)
            }

            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(checkboxButton.snp.trailing).offset(8)
                make.centerY.equalToSuperview()
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
