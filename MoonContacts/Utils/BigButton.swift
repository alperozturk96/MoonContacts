//
//  BigButton.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 21.10.2021.

/*
 This class responsible for making UIButton look like an icon.
 */

//

import UIKit


final class BigButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.setTitle("", for: .normal)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.bounds.insetBy(dx: -20, dy: -20).contains(point)
    }
}
