//
//  SearchView.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 21.12.2021.
//


import Contacts
import ContactsUI

final class ContactPermissionProvider {
    var store: CNContactStore
    
    required init(store: CNContactStore) {
        self.store = store
    }
    
    func askUserPermissionToAccessContactList(){
        store.requestAccess(for: .contacts) { didAuthorize, err in
            print("authorizationStatus is: ",didAuthorize)
        }
    }
}
