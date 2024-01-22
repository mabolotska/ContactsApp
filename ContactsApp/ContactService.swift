//
//  ContactService.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 21/01/24.
//

import Foundation
import Contacts


protocol ContactService {
    func grantAccess(completion: @escaping (Bool) -> Void)
    func loadContacts(completion: @escaping([Contact]) -> Void)
}



final class ContactServiceImpl: ContactService {
    func grantAccess(completion: @escaping (Bool) -> Void) {
        store.requestAccess(for: .contacts) { isGrant, error in
            print(error?.localizedDescription as Any)
            completion(isGrant)
        }
    }
    
   private let store = CNContactStore()
    
    func loadContacts(completion: @escaping ([Contact]) -> Void) {
        let queue = DispatchQueue(label: "contacts - queue")
        let keys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey
            ] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        queue.async { [weak self] in
            guard let self = self else {return }//to avoid ? in store.enumerate
            do {
                var cnContacts = [CNContact]()
                
    //            let predicate = CNContact.predicateForContacts(matchingName: "Ann")
    //
    //
    //            cnContacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
                
                try self.store.enumerateContacts(with: request) { contact, _ in
                    cnContacts.append(contact)
                }
                
                let contacts = cnContacts.map { cnContact in
                    let phoneLabelValue = cnContact.phoneNumbers.first {
                        $0.label == CNLabelPhoneNumberMain
                    }
                    let phone = phoneLabelValue?.value.stringValue ?? "no phone"
                    
                    return Contact(
                        name: "\(cnContact.givenName)",
                        phone: phone
                    )
                }
                DispatchQueue.main.async {
                    completion(contacts)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        
    }
    
    
}
