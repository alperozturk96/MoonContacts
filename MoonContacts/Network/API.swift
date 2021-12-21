//
//  API.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 19.10.2021.
//

import Foundation
import Combine

enum API {
    static let resultWrapper = ResultWrapper()
    static let tallinBaseUrl = URL(string: AppConst.tallinJobAppLink)!
    static let tartuBaseUrl = URL(string: AppConst.tartuJobAppLink)!
}

extension API {
    
    static func tallinEmployeeList() -> AnyPublisher<Employees, Error> {
        let request = URLRequest(url: tallinBaseUrl.appendingPathComponent("employee_list/"))
        return resultWrapper.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func tartuEmployeeList() -> AnyPublisher<Employees, Error> {
        let request = URLRequest(url: tartuBaseUrl.appendingPathComponent("employee_list/"))
        return resultWrapper.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
