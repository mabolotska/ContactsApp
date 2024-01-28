//
//  CheckboxTableViewCell.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 24/01/24.
//

import UIKit

class CheckboxTableViewCell: UITableViewCell {

    let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "uncheck"), for: .normal)
        button.setImage(UIImage(named: "check"), for: .selected)
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
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
}

