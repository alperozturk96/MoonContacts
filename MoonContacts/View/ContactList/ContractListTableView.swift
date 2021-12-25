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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeeManager = EmployeeManager(employees: VM.employees)
        VM.selectedEmployee =  employeeManager.findSelectedEmployee(fullName: VM.contactList[indexPath.section].names[indexPath.row])
        
        let isRegisteredInDevice = VM.contactList[indexPath.section].isInDevice[safe:indexPath.row] ?? false
        
        if isRegisteredInDevice {
            VM.selectedContact = VM.contactList[indexPath.section].contact[safe: indexPath.row]
        }
        else
        {
            VM.selectedContact = nil
        }
        
        
        if VM.selectedEmployee != nil {
            performSegue(withIdentifier: SegueIdentifiers.contactListToContactDetail, sender: nil)
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
        guard let cell = (employeeTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.employeeTableViewIdentifier) as? ContactListTableCell) else {
            return UITableViewCell()
        }
        
        let section = VM.contactList[indexPath.section]
        let fullName = section.names[indexPath.row]
        let isRegisteredInDevice = section.isInDevice[safe:indexPath.row]
        
        if isRegisteredInDevice == true
        {
            cell.button.isHidden = false
        }
        else
        {
            cell.button.isHidden = true
        }
        
        cell.textLabel?.text = fullName
        
        if let contact = section.contact[safe:indexPath.row]{
            cell.buttonTapCallback = {
                self.openNativeContactDetailScreen(contact: contact)
            }
        }

        return cell
    }
    
    
}
