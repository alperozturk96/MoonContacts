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
    
    var contactsInDevice:[Contact]? = nil
    var employees = [Employee]()
    var selectedEmployee:Employee?
    var selectedContact:CNContact?
    var contactList = [ContactListSection]()
    let loadingIndicator = Box(true) // Default value is true because app as soon as it starts make api call.
    var untouchedList:[ContactListSection] = [ContactListSection]() // It holds default list.
    
    var cancellables = Set<AnyCancellable>() //Cancellables are automatically calls cancel due to Apple documentation. So no worries for memory leak.
    
    
    // Passing publisher as parameter provides us to make fake network call for unit test.
    func fetchTallinEmployeeList(_ publisher: AnyPublisher<Employees, Error>,onSuccess: @escaping (_ employeeList:Employees)->(), onFailure: @escaping (_ error:Any)->())
    {
        publisher
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: print("tallinEmployeeList fetched")
                case .failure(let err): onFailure("error caught at tallinEmployeeList: \(err)")
                }
            }, receiveValue: { response in
                onSuccess(response)
            }).store(in: &cancellables)
    }
    
    func fetchTartuEmployeeList(_ publisher: AnyPublisher<Employees, Error>,onSuccess: @escaping (_ employeeList:Employees)->(), onFailure: @escaping (_ error:Any)->())
    {
       publisher
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:  print("tartuEmployeeList fetched")
                case .failure(let err): onFailure("error caught at tartuEmployeeList: \(err)")
                }
            }, receiveValue: { response in
                onSuccess(response)
            }).store(in: &cancellables)
    }
    
    func fetchContactsFromDevice(){
        let contactManager = ContactManager.init(contactsInDevice: [Contact](), contacts: [CNContact](), contactStore: CNContactStore())
        contactsInDevice = contactManager.fetchContactListFromDevice()
    }
    
    func prepareContactList(){
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        let employeeManager = EmployeeManager(employees: employees)
        contactList = getGroupedContactList(employeeManager: employeeManager, employees: employees)
        
        if authorizationStatus == .authorized {
            fetchContactsFromDevice()
            if var contactsInDevice = contactsInDevice {
                compareContractLists(&contactsInDevice, &contactList)
            }
        }
        
        untouchedList = contactList
    }
    
    //inout provides mutating parameters
    func compareContractLists(_ inDeviceContracts: inout [Contact], _ downloadedContracts: inout [ContactListSection]){
        for i in 0..<downloadedContracts.count{
            for j in 0..<downloadedContracts[i].names.count{
                for k in 0..<inDeviceContracts.count{
                    if downloadedContracts[i].names[j].caseInsensitiveCompare(inDeviceContracts[k].fullName) == .orderedSame{
                        downloadedContracts[i].isInDevice[j] = true
                        downloadedContracts[i].contact[j] = inDeviceContracts[k].contact
                    }
                }
            }
        }
    }
    
    //Grouping existed contact list and divide into sections.
    func getGroupedContactList(employeeManager: EmployeeManager, employees: [Employee]) -> [ContactListSection]{
        let uniqueEmployees = employeeManager.getUniqueEmployees()
        
        let groupedDictionary = Dictionary(grouping: uniqueEmployees, by: {String($0.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        var emptyContactList = [CNContact]()
        emptyContactList.append(CNContact())
        
        return keys.map{ ContactListSection(letter: $0, names: groupedDictionary[$0]!.sorted(), isInDevice: [false], contact: emptyContactList, employee: employees) }
    }
}
