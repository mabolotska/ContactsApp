//
//  ViewController.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 21/01/24.
//

import UIKit
import Contacts

enum SortingType {
    case ascending
    case descending
}

enum SortingProperty {
    case name
    case surname
}



class ContactsViewController: UIViewController, FilteringViewDelegate {
    func didApplyFilters() {
           overlayImageView.isHidden = false
       }

    var allContacts: [Contact] = []
    var filteredContacts: [Contact] = []
    var sortedContacts: [Contact] = []
    private var cellId = "ContactCellID"
    var cnContacts = [CNContact]()
    let firstImage = UIImage(systemName: "list.bullet")
    let overlayImageView = UIImageView(image: UIImage(named: "Ellipse"))
    
    private let service: ContactService = ContactServiceImpl()
    
 
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        return tableView
    }()
    

    lazy var customBarButtonView: CustomBarButtonView = {
         let customView = CustomBarButtonView()
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSorting))
         customView.addGestureRecognizer(tapGesture)
        customView.isUserInteractionEnabled = true
         
         return customView
     }()
    
    let overlayImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Ellipse")
        image.contentMode = .scaleAspectFit
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        view.addSubview(tableView)
       title = "Contacts"
        
        navigationController?.navigationBar.prefersLargeTitles = true

        readJSONFile()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
       navigationItem.rightBarButtonItems = makeRightBarButtonItems()
      
   //     navigationItem.rightBarButtonItem = customBarButtonItem
        
        
      sortedContacts = allContacts.sorted {
            $0.name?.localizedCaseInsensitiveCompare($1.name!) == .orderedAscending
                     
                   }
        
      
    }
    
  
   

//    func loadData() {
//        service.dgfd { [weak self] contacts in
//            self?.sortedContacts = contacts
//            self?.tableView.reloadData()
//        }
//    }
    
    
    @objc func didTapFilter() {

        let modalViewController = FilteringViewController()
            modalViewController.contactsViewController = self
            modalViewController.delegate = self
            modalViewController.modalPresentationStyle = .formSheet
            modalViewController.modalTransitionStyle = .crossDissolve
            present(modalViewController, animated: true, completion: nil)
    }
    
    @objc func didTapSorting() {
        let modalViewController = SortingVC()
            modalViewController.contactsViewController = self
            
            modalViewController.modalPresentationStyle = .formSheet
            modalViewController.modalTransitionStyle = .crossDissolve
            present(modalViewController, animated: true, completion: nil)

    }
    

    
    func loadData(sortingType: SortingType, sortingProperty: SortingProperty) {
        switch sortingProperty {
            
        case .name:
            sortedContacts = allContacts.sorted {
                if sortingType == .ascending {
                    return  $0.name?.localizedCaseInsensitiveCompare($1.name!) == .orderedAscending
                    
                }
                else {
                    return  $0.name?.localizedCaseInsensitiveCompare($1.name!) == .orderedDescending
                }
            }
    
        

        case .surname:
        
            sortedContacts = allContacts.sorted {
                if sortingType == .ascending {
                    return  $0.surname?.localizedCaseInsensitiveCompare($1.surname!) == .orderedAscending
                    
                }
                else  {
                    return  $0.surname?.localizedCaseInsensitiveCompare($1.surname!) == .orderedDescending
                }
            
        }
        }
        
        allContacts = sortedContacts
    
        tableView.reloadData()
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        allContacts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        let contact = allContacts[indexPath.row]
   
        cell.configure(with: contact)
        return cell
        
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 172.0
    }
    
}



extension ContactsViewController {
    func initialize() {
        view.backgroundColor = .systemBackground
    }

    func makeRightBarButtonItems() -> [UIBarButtonItem] {
        let customButton = UIButton(type: .custom)
        customButton.setImage(firstImage, for: .normal)
        customButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
        
        overlayImageView.contentMode = .scaleAspectFit
        customButton.addSubview(overlayImageView)

        overlayImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(10)
        }
        overlayImageView.isHidden = true 
        let sortingButtonItem = UIBarButtonItem(customView: customButton)

    
        let filterBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(didTapSorting))

        return [
         
                filterBarButtonItem,
                sortingButtonItem]
    }
    
    
    func readJSONFile() {
        let fileName = "db"
        let fileType = "json"
        
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType){
            do{
                let jsonData = try Data(contentsOf: URL(filePath: path),options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let model = try decoder.decode(Model.self, from: jsonData)
                if let contacts = model.contacts {
                    allContacts = contacts
           
 
                    tableView.reloadData()
                }
            }
            catch{
              print("Json file not found")
            }
            
            
        }else
        {
            
        }
        
    }
}
