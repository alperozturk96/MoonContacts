//
//  ContactListProviderVM.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 25.12.2021.
//
import Combine

// We can put network call in ContactListVM but if we do that we are breaking Single Responsibility Princible.
// Seperation between classes are provide us to flexibility.

final class ContactListProviderVM {
    
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

}
