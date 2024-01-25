//
//  LoginVC.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 23/01/24.
//

import UIKit

class LoginVC: UIViewController {
    private let service: ContactService = ContactServiceImpl()
    
    
    private let logo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        return image
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(logo)
        
        logo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(100)
            $0.width.equalTo(100)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.logo.alpha = 0  // Hide the logo
            }
            
            self?.service.grantAccess { isGranted in
                DispatchQueue.main.async {
                    guard isGranted else {
                        // Show an alert to inform the user about the need for contacts access
                        self?.showAccessAlert()
                        return
                    }
                    
                    // Permission granted, proceed to ContactsViewController
                    let vc = ContactsViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .black
        }
        
        
        func showAccessAlert() {
            let alert = UIAlertController(
                title: "Permission Required",
                message: "To show contacts, please grant access to your contacts in Settings.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                // Open the app settings
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })
            
            present(alert, animated: true, completion: nil)
        }
    }
    

