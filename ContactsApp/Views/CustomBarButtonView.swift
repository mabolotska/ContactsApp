//
//  CustomBarButtonView.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 27/01/24.
//

import UIKit

class CustomBarButtonView: UIView {

    private var button: UIButton = {
        let button = UIButton(type: .system)
   //     button.setImage(UIImage(named: "checked"), for: .normal)
        return button
    }()

    private var overlayImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Ellipse")
        image.contentMode = .scaleAspectFit
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // Create the button
        button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        // Create the overlay image view
        overlayImageView = UIImageView()
        overlayImageView.image = UIImage(named: "Ellipse") // Replace with your overlay image name
        overlayImageView.contentMode = .scaleAspectFit
        overlayImageView.isHidden = true

        // Add the button and overlay image view as subviews
        addSubview(button)
        addSubview(overlayImageView)

        // Layout using SnapKit
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        overlayImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(10)
        }
    }

    @objc  func didTapButton() {
        // Toggle the visibility of the overlay image view
        overlayImageView.isHidden = !overlayImageView.isHidden


    }
}



