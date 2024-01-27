//
//  Contact.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 21/01/24.
//

import Foundation


//struct Contact {
//    let name: String
//    let phone: String
//}


struct Model: Codable {
    let contacts: [Contact]?
}

// MARK: - Contact
struct Contact: Codable {
//    let id: Int?
    let name, surname, email: String?
    let messenger: Messenger?
    let phone: String?
}

// MARK: - Messenger
struct Messenger: Codable {
    let telegram: Bool?
    let whatsapp, viber, signal: Bool?
    let email: Bool?
}


