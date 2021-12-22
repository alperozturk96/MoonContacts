//
//  ContractListVM.swift
//  MoonContactsTests
//
//  Created by Alper Öztürk on 22.12.2021.
//

import XCTest
import ContactsUI
import Contacts
@testable import MoonContacts

class ContractListVMTests: XCTestCase {
    var sut:ContactListVM!
    
    override func setUp() {
        sut = ContactListVM()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testGetGroupedContactList_WhenGivenEmployeeList_ShouldReturnContactListSection() {
        //Arrange
        let einstein = Employee.init(fname: "Albert",
                                                lname: "Eeinstein",
                                                position: "Physicist",
                                                contact_details: ContactDetails.init(email: "einstein@fx.com", phone: "+314314314314"),
                                                projects: ["Gravitational Waves"])
        
        let kafka = Employee.init(fname: "Franz",
                                                lname: "Kafka",
                                                position: "Novelist",
                                                contact_details: ContactDetails.init(email: "kafka@roma.com", phone: "+00000000000"),
                                                projects: [" Metamorphosis"])
        
        let employees = [einstein,einstein,kafka]
        let uniqueEmployeesListCount = employees.count - 1
        let employeeManager = EmployeeManager.init(employees: employees)
        
        
        //Act
        let contactList = sut.getGroupedContactList(employeeManager: employeeManager, employees: employees)
        
        //Assert
        XCTAssertNotNil(contactList)
        XCTAssertEqual(uniqueEmployeesListCount , contactList.count)
    }
    
}
