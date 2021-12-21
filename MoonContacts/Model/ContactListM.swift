//
//  ContactListM.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 19.10.2021.
//

import Foundation

struct Employees:Codable {
    let employees:[Employee]?
}

struct Employee: Codable {
    let fname:String?
    var lname:String?
    let position:String?
    let contact_details:ContactDetails?
    let projects:[String]?
    
    func fullName() -> String? {
        guard let lastName = self.lname else { return nil}
        guard let firstName = self.fname else { return nil}
        
        return lastName + " " + firstName
    }
    
}


struct ContactDetails: Codable {
    let email:String?
    let phone:String?
}
