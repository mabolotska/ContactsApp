//
//  TestVC.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 23/01/24.
//

import UIKit

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let checkmarkButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Add subviews to the cell's content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkButton)

        // Configure constraints using SnapKit
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }

        checkmarkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(30) // You can adjust the size
        }

        // Configure checkmark button appearance
        checkmarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        checkmarkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)

        // Add target for button tap
        checkmarkButton.addTarget(self, action: #selector(checkmarkButtonTapped), for: .touchUpInside)
    }

    @objc private func checkmarkButtonTapped() {
        // Handle checkmark button tap
        // You can toggle the selection state, update UI, etc.
        checkmarkButton.isSelected.toggle()
    }
}


class TableViewController: UITableViewController {
    var data = ["Item 1", "Item 2", "Item 3", "Item 4"]
    var selectedRows = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.allowsMultipleSelection = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Select/Deselect All",
            style: .plain,
            target: self,
            action: #selector(selectDeselectAll)
        )
    }

    @objc private func selectDeselectAll() {
        
        let shouldSelectAll = selectedRows.count < data.count

        for row in 0..<data.count {
            let indexPath = IndexPath(row: row, section: 0)

            if shouldSelectAll {
                
                          
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                selectedRows.insert(row)
            } else {
                
                
                
                tableView.deselectRow(at: indexPath, animated: true)
                selectedRows.remove(row)
            }

           
            
            if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
                cell.checkmarkButton.isSelected = shouldSelectAll
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        cell.titleLabel.text = data[indexPath.row]
        cell.checkmarkButton.isSelected = selectedRows.contains(indexPath.row)
        return cell
    }

    // Handle the selection/deselection of cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows.insert(indexPath.row)
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRows.remove(indexPath.row)
    }
}
