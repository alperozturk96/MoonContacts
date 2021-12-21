//
//  ContactDetailVC.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 19.10.2021.
//


import ContactsUI
import Contacts
import UIKit

class ContactDetailVC: UIViewController {
    
    @IBOutlet private weak var projectsCVHeight: NSLayoutConstraint!
    @IBOutlet private weak var experienceLabel: UILabel!
    @IBOutlet private weak var btnOpenContract: UIButton!
    @IBOutlet private weak var projectsCV: UICollectionView!
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    
    var employee:Employee?
    var contact:CNContact!
    let projectsTableViewIdentifier = "projectsTable"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContactDetail()
        checkExistanceOfContact()
    }
    
    private func checkExistanceOfContact(){
        if contact != nil {
            btnOpenContract.isHidden = false
            btnOpenContract.addAction {
                self.openNativeContactDetailScreen(contact: self.contact)
            }
        }
    }
    
    private func loadContactDetail(){
        guard let employee = employee else { return }
        guard let firstName = employee.fname else { return }
        guard let lastName = employee.lname else { return }

        fullName.text = lastName + " " + firstName
        phoneLabel.text = employee.contact_details?.phone
        emailLabel.text = employee.contact_details?.email
        positionLabel.text = employee.position
        
        
        if employee.projects == nil {
            projectsCVHeight.constant = 0
            experienceLabel.text = "No Project Found"
            projectsCV.isHidden = true
        }
        else
        {
            initProjectCV()
        }
    }
    
    func openNativeContactDetailScreen(contact:CNContact){
        let vc = CNContactViewController(for: contact)
        vc.contactStore = CNContactStore()
        vc.delegate = self
        vc.allowsActions = true
        vc.allowsEditing = true
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func initProjectCV(){
        projectsCV.register(ProjectCell.self, forCellWithReuseIdentifier: projectsTableViewIdentifier)
        projectsCV.dataSource = self
        projectsCV.delegate = self
    }
}


extension ContactDetailVC: CNContactViewControllerDelegate{
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
}
