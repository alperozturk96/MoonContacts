//
//  ContactManager.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 20.10.2021.

/*
    This class responsible for fetching contact list from device and prepare Contact array for usage.
*/

//

import ContactsUI

final class ContactManager {
    
    func fetchContactListFromDevice() -> [Contact]{
        var contactsInDevice = [Contact]()
        var contacts = [CNContact]()
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactUrlAddressesKey,
            CNContactVCardSerialization.descriptorForRequiredKeys(),
            CNContactPropertyAttribute,
            CNContactViewController.descriptorForRequiredKeys(),
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do
        {
            allContainers = try contactStore.containers(matching: nil)
        }
        catch
        {
            print("Error fetching containers")
        }
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                contacts.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        
        for item in contacts {
            let contact = Contact(contact: item, fullName: item.familyName + " " + item.givenName)
            contactsInDevice.append(contact)
        }
     
        return contactsInDevice
        
    }
    
    
}
