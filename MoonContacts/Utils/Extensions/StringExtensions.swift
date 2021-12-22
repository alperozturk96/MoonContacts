//
//  StringExtensions.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 22.12.2021.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
