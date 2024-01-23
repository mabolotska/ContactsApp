//
//  UiViewController + Extension.swift
//  Exercises
//
//  Created by Maryna Bolotska on 22/01/24.
//


import SwiftUI

extension UIViewController {
    
    
    private struct Preview: UIViewControllerRepresentable {

    let viewController: UIViewController

    func makeUIViewController(context: Context) -> some UIViewController {

    viewController

    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

    }

    func showPreview() -> some View {

    Preview(viewController: self).edgesIgnoringSafeArea(.all)

    }

    }

    

