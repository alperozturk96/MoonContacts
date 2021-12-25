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
    var employee:Employee!
    var employees:Employees!
    var resultWrapper:MockResultWrapper!
    
    override func setUp() {
        sut = ContactListVM()
        employee = Employee.init(fname: "Steve",
                                     lname: "Carrell",
                                     position: "DirectX Team Lead",
                                     contact_details: ContactDetails.init(email: "stevedx10@hotmale.com", phone: "+9999221123123"),
                                     projects: ["Windows 95", "Windows 2000"])
        
        
        employees = Employees.init(employees: [employee])
        resultWrapper = MockResultWrapper()
    }
    
    override func tearDown() {
        sut = nil
        resultWrapper = nil
        employees = nil
        employee = nil
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
    
    
    func testFetching_WhenGivenURLIsEmpty_ShouldReturnTrue(){
        //Act
        if resultWrapper.mockPublisher(url: "") == nil {
            //Assert
            XCTAssertTrue(true)
        }
        else
        {
            XCTFail()
        }
    }
    
    func testFetchTallinEmployeesList_WhenReceivedDifferentJSONResponse_ShouldReturnError(){
        //Arrange
        MockURLProtocol.stubResponseHandler = { request in
            return (HTTPURLResponse(), Data())
        }
        
        let expectation = self.expectation(description: "Error Response Expectation")
        
        guard let publisher = resultWrapper.mockPublisher(url: "https://tallinn-jobapp.aw.ee/employee_list/") else {
            XCTFail()
            return
        }
        
        //Act
        sut.fetchTallinEmployeeList(publisher) { employees in
            XCTFail()
        } onFailure: { error in
            //Assert
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testFetchTallinEmployeesList_WhenGivenSuccesfullResponse_ShouldReturnEqual(){
        //Arrange
        var mockData:Data!
        
        do
        {
            mockData = try JSONEncoder().encode(employees)
        }
        catch
        {
            XCTFail()
        }
        
        //Insert MockData
        MockURLProtocol.stubResponseHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        guard let publisher = resultWrapper.mockPublisher(url: "https://tallinn-jobapp.aw.ee/employee_list/") else {
            XCTFail()
            return
        }
        
        let expectation = self.expectation(description: "Succesfull Response Expectation")
        
        //Act
        sut.fetchTallinEmployeeList(publisher) { employees in
            //Assert
            XCTAssertNotNil(employees)
            expectation.fulfill()
        } onFailure: { error in
            XCTFail()
        }
        
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testFetchTartuEmployeesList_WhenReceivedDifferentJSONResponse_ShouldReturnError(){
        //Arrange
        MockURLProtocol.stubResponseHandler = { request in
            return (HTTPURLResponse(), Data())
        }
        
        let expectation = self.expectation(description: "Error Response Expectation")
        
        guard let publisher = resultWrapper.mockPublisher(url: "https://tartu-jobapp.aw.ee/employee_list/") else {
            XCTFail()
            return
        }
        
        //Act
        sut.fetchTartuEmployeeList(publisher) { employees in
            XCTFail()
        } onFailure: { error in
            //Assert
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testFetchTartuEmployeesList_WhenGivenSuccesfullResponse_ShouldReturnEqual(){
        //Arrange
        var mockData:Data!
        
        do
        {
            mockData = try JSONEncoder().encode(employees)
        }
        catch
        {
            XCTFail()
        }
        
        //Insert MockData
        MockURLProtocol.stubResponseHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = self.expectation(description: "Succesfull Response Expectation")
        
        guard let publisher = resultWrapper.mockPublisher(url: "https://tartu-jobapp.aw.ee/employee_list/") else {
            XCTFail()
            return
        }
        
        //Act
        sut.fetchTartuEmployeeList(publisher) { employees in
            //Assert
            XCTAssertNotNil(employees)
            expectation.fulfill()
        } onFailure: { error in
            XCTFail()
        }
        
        self.wait(for: [expectation], timeout: 5)
    }
    
}
