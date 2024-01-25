//
//  ViewController.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 21/01/24.
//

import UIKit


class ContactsViewController: UIViewController {
 //   private var cellModels: [Contact] = [] //same as cellModels
    var allContacts: [Contact] = []
    
    private var cellId = "ContactCellID"
    
    private let service: ContactService = ContactServiceImpl()
    
    var fm = FileManager.default
    var mainUrl: URL? = Bundle.main.url(forResource: "db", withExtension: "json")
    var subUrl: URL?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        view.addSubview(tableView)
       title = "Contacts"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        getData()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItems = makeRightBarButtonItems()
    }
    
  
    func getData() {
        do {
            let documentDirectory = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            subUrl = documentDirectory.appendingPathComponent("db.json")
            loadFile(mainPath: mainUrl!, subPath: subUrl!)
        } catch {
            print(error)
        }
    }
    
    func loadFile(mainPath: URL, subPath: URL){
        if fm.fileExists(atPath: subPath.path){
            decodeData(pathName: subPath)
            
            
        }else{
            decodeData(pathName: mainPath)
        }
        
 
    }
    
    func decodeData(pathName: URL){
        do{
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            let model = try decoder.decode(Model.self, from: jsonData)
                        if let contacts = model.contacts {
                            allContacts = contacts
                            tableView.reloadData()
                        }
            
         //   allContacts = try decoder.decode([Contact].self, from: jsonData)
        } catch {
            print("Error decoding data: \(error)")
        }
    }


//    func loadData() {
//        service.loadContacts { [weak self] contacts in
//            self?.allContacts = contacts
//            self?.tableView.reloadData()
//        }
//    }
//    
    
    @objc func didTapFilter() {
        
        let modalViewController = FilteringViewController()
        modalViewController.modalPresentationStyle = .formSheet
               modalViewController.modalTransitionStyle = .crossDissolve
               present(modalViewController, animated: true, completion: nil)
    }
    
    @objc func didTapSorting() {
        
        
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
       allContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        let contact = allContacts[indexPath.row]
   //     cell.textLabel?.text = contact.name
        cell.configure(with: contact)
        return cell
        
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 122.0
    }
    
}



extension ContactsViewController {
    func initialize() {
        
        view.backgroundColor = .systemBackground
     
    }
    
    func makeRightBarButtonItems() -> [UIBarButtonItem] {
        let addBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(didTapFilter))
        let directBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(didTapSorting))
        return [directBarButtonItem, addBarButtonItem]
    }
   
}
