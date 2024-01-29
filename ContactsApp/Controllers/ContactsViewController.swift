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

enum MessengerType {
    case telegram
    case viber
    case whatsapp
    case signal
}



class ContactsViewController: UIViewController, FilteringViewDelegate, SortingViewDelegate {
  
    
    var filteredMessengerType: MessengerType?

    var allContacts: [Contact] = []
    var sortedContacts: [Contact] = []
    private var cellId = "ContactCellID"
    var cnContacts = [CNContact]()
    let firstImage = UIImage(systemName: "list.bullet")
    let overlayImageView = UIImageView(image: UIImage(named: "Ellipse"))
    
    private let service: ContactService = ContactServiceImpl()
    
    var showFilteredPeopleCount: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    

    
    var filteredPeople: [Contact] {
            if showFilteredPeopleCount, let messengerType = filteredMessengerType {
                return allContacts.filter {
                    switch messengerType {
                    case .telegram:
                        return $0.messenger?.telegram == true
                    case .viber:
                        return $0.messenger?.viber == true
                    case .whatsapp:
                        return $0.messenger?.whatsapp == true
                    case .signal:
                        return $0.messenger?.signal == true
                    }
                }
            } else {
                return allContacts
            }
        }
    func filterPeopleByMessengerType(_ messengerType: MessengerType?) {
         filteredMessengerType = messengerType
         tableView.reloadData()
     }
 
    
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
        modalViewController.delegate = self
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
    
    
    func didApplySorting() {
        tableView.reloadData()
           dismiss(animated: true)
    
       }

    func didApplyFilters() {
           overlayImageView.isHidden = false
       }

}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
   //     allContacts.count
        filteredPeople.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        let person = filteredPeople[indexPath.row]
        cell.configure(with: person)
        return cell
        
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 172.0
    }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // Update your data source
               allContacts.remove(at: indexPath.row)

               // Update the table view to reflect the changes
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
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


extension ContactsViewController {
    func sortTelegram() {
        showFilteredPeopleCount.toggle()
               filteredMessengerType = showFilteredPeopleCount ? .telegram : nil
               tableView.reloadData()
    }
    
    func sortViber() {
        showFilteredPeopleCount.toggle()
        filteredMessengerType = showFilteredPeopleCount ? .viber : nil
               tableView.reloadData()
    }
    
    func sortWhatsapp() {
        showFilteredPeopleCount.toggle()
        filteredMessengerType = showFilteredPeopleCount ? .whatsapp : nil
               tableView.reloadData()
    }
    
    func sortSignal() {
        showFilteredPeopleCount.toggle()
        filteredMessengerType = showFilteredPeopleCount ? .signal : nil
               tableView.reloadData()
    }
}
