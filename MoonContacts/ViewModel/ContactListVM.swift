//
//  ContactListVM.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 20.10.2021.
//

import Foundation
import Combine
import ContactsUI
import Contacts

final class ContactListVM:NSObject {
    
    var contactsInDevice = [Contact]()
    var employees = [Employee]()
    var selectedEmployee:Employee?
    var selectedContact:CNContact?
    var contactList = [ContactListSection]()
    var untouchedList:[ContactListSection] = [ContactListSection]()
    
    func fetchTartuEmployeeList(publisher: AnyPublisher<Employees, Error>, complicated: @escaping (_ employeeList:Employees)->(), error: @escaping (_ error:Any)->()) -> AnyCancellable
    {
        return publisher
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: print("tartuEmployeeList fetched")
                case .failure(let err): error("error caught at tartuEmployeeList: \(err)")
                }
            }, receiveValue: { response in
                complicated(response)
            })
    }
    
    func fetchTallinEmployeeList(publisher: AnyPublisher<Employees, Error>, complicated: @escaping (_ employeeList:Employees)->(), error: @escaping (_ error:Any)->()) -> AnyCancellable
    {
        return publisher
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: print("tallinEmployeeList fetched")
                case .failure(let err): error("error caught at tallinEmployeeList: \(err)")
                }
            }, receiveValue: { response in
                complicated(response)
            })
    }
    
    //Grouping existed contact list and divide into sections.
    func groupContactListItems(){
        let employeeManager = EmployeeManager(employees: employees)
        let uniqueEmployees = employeeManager.getUniqueEmployees()
        
        let groupedDictionary = Dictionary(grouping: uniqueEmployees, by: {String($0.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        var empthyContactList = [CNContact]()
        empthyContactList.append(CNContact())
        
        contactList = keys.map{ ContactListSection(letter: $0, names: groupedDictionary[$0]!.sorted(), isInDevice: [false], contact: empthyContactList, employee: employees) }
        
        //checkContactExistanceInDevice
        for i in 0..<contactList.count{
            for j in 0..<contactList[i].names.count{
                for k in 0..<contactsInDevice.count{
                    if contactList[i].names[j].caseInsensitiveCompare(contactsInDevice[k].fullName) == .orderedSame{
                        contactList[i].isInDevice[j] = true
                        contactList[i].contact[j] = contactsInDevice[k].contact
                    }
                }
            }
        }
        
        untouchedList = contactList
    }
}
