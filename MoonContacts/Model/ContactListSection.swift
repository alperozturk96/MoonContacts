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
    var names : [String]
    var isInDevice:[Bool]
    var contact:[CNContact]
    var employee:[Employee]
}
