//
//  ContactService.swift
//  ContactsApp
//
//  Created by Maryna Bolotska on 21/01/24.
//

import Foundation
import Contacts
import SwiftUI


protocol ContactService {
    func grantAccess(completion: @escaping (Bool) -> Void)
 //   func loadContacts(completion: @escaping([Contact]) -> Void)
//    func filtering(completion: @escaping ([Contact]) -> Void)
  
}



final class ContactServiceImpl: ContactService {
    func grantAccess(completion: @escaping (Bool) -> Void) {
        store.requestAccess(for: .contacts) { isGrant, error in
            print(error?.localizedDescription as Any)
            completion(isGrant)
        }
    }
    
    
//    let firstVc = ContactsViewController()
   private let store = CNContactStore()
    let keys = [
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey,
        CNContactInstantMessageAddressesKey
        ] as [CNKeyDescriptor]
    var cnContacts = [CNContact]()
    weak var contactsViewController: ContactsViewController?
    
    
    
    
//    
//    func loadContacts(completion: @escaping ([Contact]) -> Void) {
//        let queue = DispatchQueue(label: "contacts - queue")
//   
//        
//        let request = CNContactFetchRequest(keysToFetch: keys)
//        
//        queue.async { [weak self] in
//            guard let self = self else {return }//to avoid ? in store.enumerate
//            do {
//                
//                
//
//                
//                try self.store.enumerateContacts(with: request) { contact, _ in
//                    self.cnContacts.append(contact)
//                }
//                
//                let contacts = cnContacts.map { cnContact in
//                    let phoneLabelValue = cnContact.phoneNumbers.first {
//                        $0.label == CNLabelPhoneNumberMobile
//                    }
//                    let phone = phoneLabelValue?.value.stringValue ?? "no phone"
//                    
//                    let emailLabelValue = cnContact.emailAddresses.first {
//                        $0.label == CNLabelEmailiCloud
//                    }
//                    
//                    let email = emailLabelValue?.value ?? "no email"
//                    
//                   
//           //         let emailAddress = cnContact.emailAddresses.first?.value as String? ?? "no email"
//                        
//               
//                        let hasTelegram = cnContact.socialProfiles.contains {
//                            $0.value.service == CNContactSocialProfilesKey
//                        }
//                    
//                    let hasWhatsapp = cnContact.socialProfiles.contains {
//                        $0.value.service == CNContactSocialProfilesKey
//                    }
//                    
//                    let hasViber = cnContact.socialProfiles.contains {
//                        $0.value.service == CNContactSocialProfilesKey
//                    }
//                    
//                    let hasSignal = cnContact.socialProfiles.contains {
//                        $0.value.service == CNContactSocialProfilesKey
//                    }
//                    let hasEmail = cnContact.socialProfiles.contains {
//                        $0.value.service == CNContactSocialProfilesKey
//                    }
//                   
//                    
//                    let messenger = Messenger(telegram: hasTelegram, whatsapp: hasWhatsapp, viber: hasViber, signal: hasSignal, email: hasEmail)
//                    
//                    return Contact(
//                        name: "\(cnContact.givenName)", 
//                        email: email as String, 
//                        messenger: messenger,
//                        phone: phone
//                    )
//                }
//                DispatchQueue.main.async {
//                    completion(contacts)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([])
//                }
//            }
//        }
//        
//    }
//    
    
    

    
    func filtering(completion: @escaping ([Contact]) -> Void) {
//                    let predicate = CNContact.predicateForContacts(matchingName: "Ann")
//                    cnContacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
        let queue = DispatchQueue(label: "contacts - queue")
        
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: CNContactStore().defaultContainerIdentifier())
                let keysToFetch = [CNContactGivenNameKey,
                                   CNContactFamilyNameKey,
                                   CNContactPhoneNumbersKey,
                                   CNContactEmailAddressesKey,
                                   CNContactInstantMessageAddressesKey]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
                fetchRequest.predicate = predicate

        queue.async { [weak self] in
            guard let self = self else {return }
            
            
            do {
                try CNContactStore().enumerateContacts(with: fetchRequest) { contact, _ in
                    self.cnContacts.append(contact)
                }
                
                let sortedContacts = cnContacts.sorted {
                    $0.givenName.localizedCaseInsensitiveCompare($1.givenName) == .orderedAscending
                    
                    
                    
       
                }
                
                
                //     filteredContacts = sortedContacts
                
                DispatchQueue.main.async {
          //          completion(sortedContacts)
                }
                
                
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    
}


//what i could use:
//enum SocialProfileType: String {
//    case telegram = "Telegram"
//    case whatsapp = "WhatsApp"
//    case viber = "Viber"
//    case signal = "Signal"
//    case email = "Email"
//}
//
//func hasSocialProfile(contact: CNContact, type: SocialProfileType) -> Bool {
//    return contact.socialProfiles.contains { $0.value.service == type.rawValue }
//}
//
//// Example usage:
//let hasTelegram = hasSocialProfile(contact: cnContact, type: .telegram)
//let hasWhatsapp = hasSocialProfile(contact: cnContact, type: .whatsapp)
//let hasViber = hasSocialProfile(contact: cnContact, type: .viber)
//let hasSignal = hasSocialProfile(contact: cnContact, type: .signal)
//let hasEmail = hasSocialProfile(contact: cnContact, type: .email)
