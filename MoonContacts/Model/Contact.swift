//
//  Contact.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 20.10.2021.
//

import Foundation
import Contacts

struct Contact {
    let contact:CNContact
    let fullName: String
}


struct ContactDetail {
    let fullName: String
    let email:String
    let phone:String
    let position:String
}
