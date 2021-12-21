//
//  MoonContactsTests.swift
//  MoonContactsTests
//
//  Created by Alper Öztürk on 22.10.2021.
//

import XCTest
import Combine

@testable import MoonContacts

class MoonContactsTests: XCTestCase {

    func testTallinEmployeeListServerResponseTime(){
        let vm = ContactListVM()
        let timeoutInSec:TimeInterval = 4
        var apiCall:AnyCancellable?
       
        let expectation = expectation(description: "Testing server response time")

        apiCall = vm.fetchTallinEmployeeList { employeeList in
           
            print("Server responded in expected time.")
            XCTAssertTrue(true)
            expectation.fulfill()
        } error: { error in
            XCTAssertNil(error)
        }

        waitForExpectations(timeout: timeoutInSec) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testTartuEmployeeListServerResponseTime(){
        let vm = ContactListVM()
        let timeoutInSec:TimeInterval = 4
        var apiCall:AnyCancellable?
       
        let expectation = expectation(description: "Testing server response time")

        apiCall = vm.fetchTartuEmployeeList { employeeList in
           
            print("Server responded in expected time.")
            XCTAssertTrue(true)
            expectation.fulfill()
        } error: { error in
            XCTAssertNil(error)
        }

        waitForExpectations(timeout: timeoutInSec) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
