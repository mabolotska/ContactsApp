//
//  FilteringViewController.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 24/01/24.
//

import UIKit

protocol FilteringViewDelegate: AnyObject {
    func didApplyFilters()
}


class FilteringViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    weak var delegate: FilteringViewDelegate?
    let firstVc = ContactsViewController()
    weak var contactsViewController: ContactsViewController?
    
    let data = ["By name A-Z", "By name Z-A", "By surname A-Z", "By surname Z-A"]
    var selectedIndexPath: IndexPath?
    
    
    var selectedRows: Set<Int> = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxCell", for: indexPath) as? CheckboxTableViewCell else {
            return UITableViewCell()
        }
        cell.contentView.backgroundColor = UIColor(red: 200/255, green: 236/255, blue: 87/255, alpha: 1)
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.white.cgColor
        cell.contentView.layer.cornerRadius = 30
        cell.titleLabel.text = data[indexPath.row]
        cell.checkboxButton.isSelected = selectedRows.contains(indexPath.row)

        
        cell.checkboxButton.tag = indexPath.row
          cell.checkboxButton.setImage(UIImage.init(named: "uncheck"), for: .normal)
          cell.checkboxButton.setImage(UIImage.init(named: "check"), for: .selected)
          cell.checkboxButton.addTarget(self, action: #selector(btnCheckUncheckClick(_sender:)), for: .touchUpInside)

          if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
              cell.checkboxButton.isSelected = true
          } else {
              cell.checkboxButton.isSelected = false
          }
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        //     toggleSelection(for: indexPath)
    }
    
    
    // MARK: - Checkbox Handling
    @objc func btnCheckUncheckClick(_sender:UIButton){
        _sender.isSelected = !_sender.isSelected
    
        
        let selectedIndex = IndexPath(row: _sender.tag, section: 0)

        if let previousSelectedIndex = selectedIndexPath {
            // Deselect the previous cell
            let cell = tableView.cellForRow(at: previousSelectedIndex) as? CheckboxTableViewCell
            cell?.checkboxButton.isSelected = false
        }

        if selectedIndexPath == selectedIndex {
            // If the same cell is tapped again, clear the selection
            selectedIndexPath = nil
        } else {
            // Update the selected index
            selectedIndexPath = selectedIndex
            // Add the selected country to the arrSelectedCountry array
       //     arrSelectedCountry = [selectedCountry]
        }

        tableView.reloadData()
     
    }
    
  
    
    let cancelButtom:UIButton = {
        let button = UIButton()
        button.setTitle("   Cancel   ", for: .normal)
        button.titleLabel?.font = UIFont(name: "Noteworthy-Bold", size: 32)
        button.layer.cornerRadius = 5
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
        return button
    }()
    
    let submitButtom:UIButton = {
        let button = UIButton()
        button.setTitle("   Apply   ", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .darkGray
        button.titleLabel?.font = UIFont(name: "Noteworthy-Bold", size: 32)
        button.addTarget(self, action: #selector(submitTap), for: .touchUpInside)
        return button
    }()
    
    
    @objc func cancelTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func submitTap() {
        delegate?.didApplyFilters()
        
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        switch selectedIndexPath.row {
        case 0:
            contactsViewController?.loadData(sortingType: .ascending, sortingProperty: .name)
        case 1:
            contactsViewController?.loadData(sortingType: .descending, sortingProperty: .name)
        case 2:
            contactsViewController?.loadData(sortingType: .ascending, sortingProperty: .surname)
        case 3:
            contactsViewController?.loadData(sortingType: .descending, sortingProperty: .surname)
        default:
            break
        }
        
        tableView.deselectRow(at: selectedIndexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
  
    
}



    
extension FilteringViewController {
    func initialize() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(cancelButtom)
        view.addSubview(submitButtom)
        tableView.register(CheckboxTableViewCell.self, forCellReuseIdentifier: "CheckboxCell")
        

        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        cancelButtom.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        submitButtom.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(cancelButtom)
        }
    }
}


