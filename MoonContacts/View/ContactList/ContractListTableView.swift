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
        let employeeManager = EmployeeManager(employees: contactListVM.employees)
        contactListVM.selectedEmployee =  employeeManager.findSelectedEmployee(fullName: contactListVM.contactList[indexPath.section].names[indexPath.row])
        
        let isRegisteredInDevice = contactListVM.contactList[indexPath.section].isInDevice[safe:indexPath.row] ?? false
        
        if isRegisteredInDevice {
            contactListVM.selectedContact = contactListVM.contactList[indexPath.section].contact[safe: indexPath.row]
        }
        else
        {
            contactListVM.selectedContact = nil
        }
        
        
        if contactListVM.selectedEmployee != nil {
            performSegue(withIdentifier: SegueIdentifiers.contactListToContactDetail, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListVM.contactList[section].names.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactListVM.contactList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactListVM.contactList[section].letter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = (employeeTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.employeeTableViewIdentifier) as? ContactListTableCell) else {
            return UITableViewCell()
        }
        
        let section = contactListVM.contactList[indexPath.section]
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
        
        // Each cell must have textLabel
        cell.textLabel?.text = fullName
     
        // If contact exist in device we can set delegate and contact into ContactListTableCell.
        if let contact = section.contact[safe:indexPath.row]{
            cell.initContact(contact)
            cell.delegate = self
        }

        return cell
    }
    
    
}
