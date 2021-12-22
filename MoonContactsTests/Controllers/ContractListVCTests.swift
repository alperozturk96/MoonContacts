//
//  ContractListVCTests.swift
//  MoonContactsTests
//
//  Created by Alper Öztürk on 22.12.2021.
//

import XCTest
import Combine
@testable import MoonContacts

class ContractListVCTests: XCTestCase {

    var employee:Employee!
    var employees:Employees!
    var tallinEmployeeListAnyCancellable:AnyCancellable?
    var tartuEmployeeListAnyCancellable:AnyCancellable?
    var resultWrapper:MockResultWrapper!
    var sut:ContactListVM!
    
    override func setUp() {
        employee = Employee.init(fname: "Steve",
                                     lname: "Carrell",
                                     position: "DirectX Team Lead",
                                     contact_details: ContactDetails.init(email: "stevedx10@hotmale.com", phone: "+9999221123123"),
                                     projects: ["Windows 95", "Windows 2000"])
        
        
        employees = Employees.init(employees: [employee])
        resultWrapper = MockResultWrapper()
        sut = ContactListVM()
    }
    
    override func tearDown() {
        sut = nil
        resultWrapper = nil
        tartuEmployeeListAnyCancellable = nil
        employees = nil
        employee = nil
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
        
        guard let publisher = resultWrapper.mockPublisher(url: "https://tallinn-jobapp.aw.ee/employee_list/") else {
            XCTFail()
            return
        }
        
        let expectation = self.expectation(description: "Error Response Expectation")
        
        //Act
        tallinEmployeeListAnyCancellable = sut.fetchTallinEmployeeList(publisher: publisher, complicated: { employees in
            XCTFail()
        }, error: { error in
            //Assert
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        
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
        tallinEmployeeListAnyCancellable = sut.fetchTallinEmployeeList(publisher: publisher, complicated: { employees in
            //Assert
            XCTAssertNotNil(employees)
            expectation.fulfill()
        }, error: { error in
            XCTFail()
        })
        
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testFetchTartuEmployeesList_WhenReceivedDifferentJSONResponse_ShouldReturnError(){
        //Arrange
        MockURLProtocol.stubResponseHandler = { request in
            return (HTTPURLResponse(), Data())
        }
        
        guard let publisher = resultWrapper.mockPublisher(url: "https://tartu-jobapp.aw.ee/employee_list/") else {
            XCTFail()
            return
        }
        
        let expectation = self.expectation(description: "Error Response Expectation")
        
        //Act
        tartuEmployeeListAnyCancellable = sut.fetchTartuEmployeeList(publisher: publisher, complicated: { employees in
            XCTFail()
        }, error: { error in
            //Assert
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        
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
        
        guard let publisher = resultWrapper.mockPublisher(url: "https://tartu-jobapp.aw.ee/employee_list/") else {
            XCTFail()
            return
        }
        
        let expectation = self.expectation(description: "Succesfull Response Expectation")
        
        //Act
        tartuEmployeeListAnyCancellable = sut.fetchTartuEmployeeList(publisher: publisher, complicated: { employees in
            //Assert
            XCTAssertNotNil(employees)
            expectation.fulfill()
        }, error: { error in
            XCTFail()
        })
        
        self.wait(for: [expectation], timeout: 5)
    }

}
