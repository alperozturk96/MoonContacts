//
//  UIButtonExtensions.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 20.10.2021.
//

import Foundation
import UIKit


//Much more easy way to add button onclick, better and cleaner than addTarget. Compatible with iOS 15 also.
extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        if #available(iOS 14, *)
        {
            addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
        }
        else
        {
            @objc class ClosureSleeve: NSObject {
                let closure:()->()
                init(_ closure: @escaping()->()) { self.closure = closure }
                @objc func invoke() { closure() }
            }
            let sleeve = ClosureSleeve(closure)
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
            objc_setAssociatedObject(self, "[\(UUID())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
