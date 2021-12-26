//
//  ContractListVM.swift
//  MoonContactsTests
//
//  Created by Alper Öztürk on 22.12.2021.
//

import XCTest
@testable import MoonContacts

class ContractListVMTests: XCTestCase {
    
    var sut:ContactListVM!
    var workers:Employees!
    var resultWrapper:MockResultWrapper!
    
    override func setUp() {
        sut = ContactListVM()
        
        let steve = Employee.init(fname: "Steve",
                                  lname: "Carrell",
                                  position: "DirectX Team Lead",
                                  contact_details: ContactDetails.init(email: "stevedx10@hotmale.com", phone: "+9999221123123"),
                                  projects: ["Windows 95", "Windows 2000"])
        
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
        
        
        workers = Employees.init(employees: [steve,einstein,einstein,kafka])
        resultWrapper = MockResultWrapper()
    }
    
    override func tearDown() {
        sut = nil
        resultWrapper = nil
        workers = nil
    }
    
    func testGetGroupedContactList_WhenGivenEmployeeList_ShouldReturnContactListSection() {
        //Arrange
        let uniqueEmployeesListCount = workers!.employees!.count - 1
        let employeeManager = EmployeeManager.init(employees: workers.employees!)
        
        
        //Act
        let contactList = sut.getGroupedContactList(employeeManager: employeeManager, employees: workers.employees!)
        
        //Assert
        XCTAssertNotNil(contactList)
        XCTAssertEqual(uniqueEmployeesListCount , contactList.count)
    }
    
}
