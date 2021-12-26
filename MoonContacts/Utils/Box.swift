//
//  Box.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 25.12.2021.
/*
 didSet property observer detects any changes and notifies Listener of any value update.
 */
//

import Foundation


final class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
