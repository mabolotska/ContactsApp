//
//  ContactCell.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 21/01/24.
//

import UIKit
import SnapKit

class ContactCell: UITableViewCell {

    func configure(with model: Contact) {
        nameLabel.text = "\(model.name ?? "No name")"
        surnameLabel.text = "\(model.surname ?? "No surname")"
        phoneLabel.text = "\(model.phone ?? "No phone")"
        emailLabel.text = model.email
        telegramLogo.isHidden = !(model.messenger?.telegram ?? true)
        whatsappLogo.isHidden = !(model.messenger?.whatsapp ?? false)
        signalLogo.isHidden = !(model.messenger?.signal ?? false)
        emailLogo.isHidden = !(model.messenger?.email ?? false)
        viberLogo.isHidden = !(model.messenger?.viber ?? false)
    }
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
//    private var userIdLabel: UILabel = {
//       let label = UILabel()
//        label.numberOfLines = 0
//        return label
//    }()
   var nameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
       label.font = UIFont(name: "Chalkduster", size: 25)
        return label
    }()
    
    var surnameLabel: UILabel = {
        let label = UILabel()
         label.numberOfLines = 0
        label.font = UIFont(name: "Chalkduster", size: 25)
         return label
     }()
    
    
    private var phoneLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private var emailLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let telegramLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "1")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let whatsappLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "2")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let signalLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "3")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let viberLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "4")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let emailLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "envelope.circle")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let stackView: UIStackView = {
         let stackView = UIStackView()
        stackView.axis = .vertical
         stackView.spacing = 5
        
         return stackView
     }()
    
    private let stackViewTwo: UIStackView = {
         let stackView = UIStackView()
        stackView.axis = .horizontal
         stackView.spacing = 2
         return stackView
     }()
}


private extension ContactCell {
    
    func initialize() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(surnameLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(phoneLabel)
        stackView.addArrangedSubview(emailLabel)
        
        contentView.addSubview(stackViewTwo)
        stackViewTwo.addArrangedSubview(telegramLogo)
        stackViewTwo.addArrangedSubview(whatsappLogo)
        stackViewTwo.addArrangedSubview(viberLogo)
        stackViewTwo.addArrangedSubview(signalLogo)
        stackViewTwo.addArrangedSubview(emailLogo)
        
        stackView.snp.makeConstraints { make in
         //   make.top.leading.trailing.equalToSuperview().offset(30)
           // make.top.trailing.equalToSuperview().offset(12)
            
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(10)
        }
        
        stackViewTwo.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalToSuperview().offset(30)
        }
        
        telegramLogo.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        whatsappLogo.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        viberLogo.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        signalLogo.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        emailLogo.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }
}
