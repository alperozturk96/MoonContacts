//
//  ContactListSection.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 20.10.2021.
//

import Foundation
import Contacts

struct ContactListSection {
    let letter : String
    let names : [String]
    var isThisContactRegisteredInDevice:[Bool]
    var contact:[CNContact]
    var employee:[Employee]
}
