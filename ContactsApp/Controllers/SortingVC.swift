//
//  SortingVC.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 27/01/24.
//

import UIKit

protocol SortingViewDelegate: AnyObject {
    func didApplySorting()
 
}

class SortingVC: UIViewController {
    weak var delegate: SortingViewDelegate?
    weak var contactsViewController: ContactsViewController?
    var selectedIndexPath: IndexPath?
    
    
    var selectedRows: Set<Int> = []
    
    private var items: [SortingModel] = [
        SortingModel(logoImage: nil, titleLabel: "Choose everything"),
        SortingModel(logoImage: UIImage(named: "2")!, titleLabel: "Viber"),
        SortingModel(logoImage: UIImage(named: "3")!, titleLabel: "Signal"),
        SortingModel(logoImage: UIImage(named: "1")!, titleLabel: "WhatsApp"),
        SortingModel(logoImage: UIImage(named: "4")!, titleLabel: "Telegram")
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
    
        inizialize()
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
        delegate?.didApplySorting()
 //       delegate?.didResetFilters()
        
//        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
//            print("No row selected")
//            // Handle the case when no row is selected (e.g., show an alert)
//            return
//        }
        
      guard let selectedIndexPath = selectedIndexPath else { return }
        

        
   tableView.deselectRow(at: selectedIndexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}



extension SortingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return items.count
       }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "SortingCell", for: indexPath) as? SortingCell else {
               return UITableViewCell()
           }
           
           let contacts = items[indexPath.row]
           cell.contentView.backgroundColor = UIColor(red: 200/255, green: 236/255, blue: 87/255, alpha: 1)
           cell.layer.borderWidth = 3
           cell.layer.borderColor = UIColor.white.cgColor
           cell.contentView.layer.cornerRadius = 30
           cell.configure(with: contacts)
           cell.checkboxButton.isSelected = selectedRows.contains(indexPath.row)
           cell.checkboxButton.tag = indexPath.row
            
          
            
            switch indexPath.row {
            case 0:
                cell.checkboxButtonAction = { [weak self] in
                    self?.selectDeselectAll()
                    if cell.checkboxButton.isEnabled == true {
                        self?.contactsViewController?.filteredMessengerType = nil
                    }
                 tableView.reloadData()
            
                }
            case 1:
                cell.checkboxButtonAction = { [weak self] in
                                   self?.contactsViewController?.sortViber()
                                   tableView.reloadData()
                               }
            case 2:
                cell.checkboxButtonAction = { [weak self] in
                                   self?.contactsViewController?.sortSignal()
                                   tableView.reloadData()
                               }
            case 3:
                cell.checkboxButtonAction = { [weak self] in
                                   self?.contactsViewController?.sortWhatsapp()
                                   tableView.reloadData()
                               }
            case 4:
                cell.checkboxButtonAction = { [weak self] in
                                   self?.contactsViewController?.sortTelegram()
                                   tableView.reloadData()
                               }
            default:
                break
            }
            
            
          

             if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
                 cell.checkboxButton.isSelected = true
             } else {
                 cell.checkboxButton.isSelected = false
             }
           
           
           
           return cell
       }
       
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           selectedIndexPath = indexPath
        
          
       }
 
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    
    @objc private func selectDeselectAll() {
        let shouldSelectAll = selectedRows.isEmpty

        for row in 0..<items.count {
            let indexPath = IndexPath(row: row, section: 0)

            if shouldSelectAll {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                selectedRows.insert(row)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
                selectedRows.remove(row)
            }

            if let cell = tableView.cellForRow(at: indexPath) as? SortingCell {
                cell.checkboxButton.isSelected = shouldSelectAll
            }
        }

        // Clear selectedRows set when deselecting all
        if !shouldSelectAll {
            selectedRows.removeAll()
        }
    }


}

extension SortingVC {
    func inizialize() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(cancelButtom)
        view.addSubview(submitButtom)
        tableView.register(SortingCell.self, forCellReuseIdentifier: String(describing: SortingCell.self))
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(370)
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
