//
//  SearchView.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 21.12.2021.
//


import Contacts
import ContactsUI

final class ContractProvider {
    var store: CNContactStore
    var authorizationStatus: CNAuthorizationStatus
  
    required init(store: CNContactStore, authorizationStatus: CNAuthorizationStatus) {
        self.store = store
        self.authorizationStatus = authorizationStatus
    }
    
    
    func askUserPermissionToAccessContactList(onDone: @escaping ()->()){
        if authorizationStatus == .notDetermined
        {
            store.requestAccess(for: .contacts) { didAuthorize,
                error in
                if didAuthorize {
                    DispatchQueue.main.async {
                        onDone()
                    }
                   
                }
            }
        }
        else if authorizationStatus == .authorized {
            DispatchQueue.main.async {
                onDone()
            }
        }
    }
}
