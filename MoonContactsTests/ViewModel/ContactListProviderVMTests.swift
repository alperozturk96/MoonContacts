//
//  ContactListProviderVMTests.swift
//  MoonContactsTests
//
//  Created by Alper Öztürk on 25.12.2021.
//

import XCTest
@testable import MoonContacts

class ContactListProviderVMTests: XCTestCase {
    
    var sut:ContactListProviderVM!
    var workers:Employees!
    var resultWrapper:MockResultWrapper!
    
    override func setUp() {
        sut = ContactListProviderVM()
        
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
            mockData = try JSONEncoder().encode(workers)
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
            mockData = try JSONEncoder().encode(workers)
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
