//
//  BaseVC.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 20.10.2021.
//

import UIKit

class BaseVC: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicator()
    }
    
    func createActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemIndigo
    }
    
    func showActivityIndicator() {
        activityIndicator?.center = self.view.center
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityIndicator != nil){
            activityIndicator?.stopAnimating()
        }
    }
    
}
