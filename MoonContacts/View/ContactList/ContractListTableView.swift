//
//  ContractListTableView.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 21.12.2021.
//

import UIKit
import Contacts
import ContactsUI


extension ContactListVC: UITableViewDataSource, UITableViewDelegate {
    
    private func openNativeContactDetailScreen(contact:CNContact){
        let vc = CNContactViewController(for: contact)
        vc.contactStore = CNContactStore()
        vc.delegate = self
        vc.allowsActions = true
        vc.allowsEditing = true
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        VM.selectedEmployee = VM.findSelectedEmployee(fullName: VM.contactList[indexPath.section].names[indexPath.row])
        let isRegisteredInDevice = VM.contactList[indexPath.section].isThisContactRegisteredInDevice[safe:indexPath.row] ?? false
        
        if isRegisteredInDevice {
            VM.selectedContact = VM.contactList[indexPath.section].contact[safe: indexPath.row]
        }
        else
        {
            VM.selectedContact = nil
        }
       
        
        if VM.selectedEmployee != nil {
            performSegue(withIdentifier: "openContactDetailFromContactList", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.contactList[section].names.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return VM.contactList.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return VM.contactList[section].letter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (employeeTableView.dequeueReusableCell(withIdentifier: VM.employeeTableViewIdentifier) as! ContactListTableCell?)!
        
        let section = VM.contactList[indexPath.section]
        let fullName = section.names[indexPath.row]
        let isRegisteredInDevice = section.isThisContactRegisteredInDevice[safe:indexPath.row]
        let contact = section.contact[safe:indexPath.row]
        
         if isRegisteredInDevice == true
         {
             cell.button.isHidden = false
         }
         else
         {
             cell.button.isHidden = true
         }
         
        cell.buttonTapCallback = {
            self.openNativeContactDetailScreen(contact: contact!)
        }
        
        cell.textLabel?.text = fullName
        return cell
    }
    
    
}
