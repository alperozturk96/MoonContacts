//
//  ContactListProtocol.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 26.12.2021.
//

import Contacts

protocol ContactListProtocol:AnyObject{
    func openContact(_ contact:CNContact)
}
