//
//  ContactListVM.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 20.10.2021.
//

import Combine
import ContactsUI
import Contacts

final class ContactListVM {
    
    var contactsInDevice = [Contact]()
    var employees = [Employee]()
    var selectedEmployee:Employee?
    var selectedContact:CNContact?

    let employeeTableViewIdentifier = "employeeTable"
    var contactList = [ContactListSection]()

    var untouchedList:[ContactListSection] = [ContactListSection]()
    
    func fetchTallinEmployeeList(complicated: @escaping (_ employeeList:Employees)->(),error: @escaping (_ error:Any)->()) -> AnyCancellable{
        return API.tallinEmployeeList().sink(receiveCompletion: { result in
            switch result {
                case .finished: print("tallinEmployeeList fetched")
                case .failure(let err): error("error catched at tallinEmployeeList: \(err)")
            }
        }, receiveValue: { response in
            complicated(response)
        })
    }
    
    func fetchTartuEmployeeList(complicated: @escaping (_ employeeList:Employees)->(),error: @escaping (_ error:Any)->()) -> AnyCancellable?{
        return API.tartuEmployeeList().sink(receiveCompletion: { result in
            switch result {
            case .finished: print("tartuEmployeeList fetched")
            case .failure(let err): error("error catched at tartuEmployeeList: \(err)")
            }
        }, receiveValue: { response in
            complicated(response)
        })
    }
    
    
    func findSelectedEmployee(fullName:String) -> Employee? {
        for i in 0..<employees.count{
            if let empfullName = employees[i].fullName(){
                if fullName == empfullName
                {
                    return employees[i]
                }
            }
        }
        
        return nil
    }
    
    func getEmployeesNames() -> [String] {
        var names = [String]()
        
        for i in 0..<employees.count {
            if let fullName = employees[i].fullName(){
                names.append(fullName)
            }
        }
        
        return names.uniqued()
    }
    
    
    //Matching contacts in device and value from remote. O(n^3) High Complexity Function.
    func checkContactExistanceInDevice() {
        for i in 0..<contactList.count{
            for j in 0..<contactList[i].names.count{
                for k in 0..<contactsInDevice.count{
                    if contactList[i].names[j].caseInsensitiveCompare(contactsInDevice[k].fullName) == .orderedSame{
                        contactList[i].isThisContactRegisteredInDevice[j] = true
                        contactList[i].contact[j] = contactsInDevice[k].contact
                    }
                }
            }
        }
    }
    
    
    //Grouping existed contact list and divide into sections.
    func groupContactListItems(){
        let groupedDictionary = Dictionary(grouping: getEmployeesNames(), by: {String($0.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        var empthyContactList = [CNContact]()
        empthyContactList.append(CNContact())
        
        contactList = keys.map{ ContactListSection(letter: $0, names: groupedDictionary[$0]!.sorted(), isThisContactRegisteredInDevice: [false], contact: empthyContactList, employee: employees) }
        
        checkContactExistanceInDevice()
        
        untouchedList = contactList
    }
    
    
    func getContactListFromDevice(){
        contactsInDevice = ContactManager().fetchContactListFromDevice()
        
        for i in 0..<contactsInDevice.count{
            print("contact in device: ",contactsInDevice[i].fullName)
        }
    }
}
