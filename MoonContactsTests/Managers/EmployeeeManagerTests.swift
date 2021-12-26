//
//  EmployeeeManagerTests.swift
//  MoonContactsTests
//
//  Created by Alper Öztürk on 22.12.2021.
//

import XCTest
@testable import MoonContacts

class EmployeeeManagerTests: XCTestCase {
    
    var employee:Employee!
    var sut:EmployeeManager!
    
    override func setUp() {
        //Arrange
        employee = Employee.init(fname: "Albert",
                                 lname: "Eeinstein",
                                 position: "Physicist",
                                 contact_details: ContactDetails.init(email: "einstein@fx.com", phone: "+314314314314"),
                                 projects: ["Gravitational Waves"])
        
        
        sut = EmployeeManager.init(employees: [employee])
    }
    
    override func tearDown() {
        employee = nil
        sut = nil
    }
    
    func testFindSelectedEmployee_WhenGivenNameExistInEmployeeList_ShouldReturnEmployee() {
        //Act
        let fullName = employee.fullName()
        
        if let fullName = fullName {
            let employee = sut.findSelectedEmployee(fullName: fullName)
            
            //Assert
            XCTAssertNotNil(employee)
        }
        else
        {
            //Assert
            XCTFail()
        }
    }
    
    func testFindSelectedEmployee_WhenGivenNameNotExistInEmployeeList_ShouldReturnNil() {
        //Act
        let fullName = "Grub"
        let employee = sut.findSelectedEmployee(fullName: fullName)
        
        //Assert
        XCTAssertNil(employee)
    }
    
}
