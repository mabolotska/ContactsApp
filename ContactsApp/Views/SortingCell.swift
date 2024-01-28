//
//  SortingCell.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 27/01/24.
//

import UIKit

class SortingCell: UITableViewCell {
    var checkboxButtonAction: (() -> Void)?
    
    func configure(with model: SortingModel) {
        titleLabel.text = model.titleLabel
        logoImage.image = model.logoImage
        
        
    }
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "viewfinder"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.addTarget(self, action: #selector(checkmarkButtonTapped), for: .touchUpInside)
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
        contentView.addSubview(logoImage)
        
        checkboxButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImage.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
    }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    @objc private func checkmarkButtonTapped() {
        checkboxButtonAction?()
        checkboxButton.isSelected.toggle()
    }
    
    
}
