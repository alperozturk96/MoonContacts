//
//  ContactDetailVC.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 19.10.2021.
//

import Contacts
import UIKit

final class ContactDetailVC: BaseVC {
    
    @IBOutlet private weak var positionView: UIView!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var phoneAreaView: UIImageView!
    @IBOutlet private weak var projectsCVHeight: NSLayoutConstraint!
    @IBOutlet private weak var experienceLabel: UILabel!
    @IBOutlet private weak var btnOpenContract: UIButton!
    @IBOutlet private weak var projectsCV: UICollectionView!
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    
    var employee:Employee?
    var contact:CNContact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let employee = employee {
            setupUI(employee: employee)
        }
       
        if let contact = contact {
            checkExistanceOfContact(contact: contact)
        }
    }
    
    func setupUI(employee:Employee){
        let contactDetail = ContactDetail.init(fullName: employee.fullName() ?? "",
                                               email: employee.contact_details?.email ?? "",
                                               phone: employee.contact_details?.phone ?? "",
                                               position: employee.position ?? "")
    
        
        loadContactDetail(contact: contactDetail)
        checkVisibilityOfViews()
        checkVisibilityOfProjectArea(projects: employee.projects)
    }
    
    func initProjectCV(){
        projectsCV.register(ProjectCell.self, forCellWithReuseIdentifier: CellIdentifiers.projectsTableViewIdentifier)
        projectsCV.dataSource = self
        projectsCV.delegate = self
    }
    
    func checkExistanceOfContact(contact:CNContact){
        btnOpenContract.isHidden = false
            
        btnOpenContract.addAction {
            self.openNativeContactDetailScreen(contact: contact)
        }
    }
    
    func checkVisibilityOfViews(){
        phoneAreaView.isHidden = !(phoneLabel.text?.count ?? 0 > 0)
        emailView.isHidden = !(emailLabel.text?.count ?? 0 > 0)
        positionView.isHidden = !(positionLabel.text?.count ?? 0 > 0)
    }
    
    func loadContactDetail(contact:ContactDetail){
        fullName.text = contact.fullName
        phoneLabel.text = contact.phone
        emailLabel.text = contact.email
        positionLabel.text = contact.position
    }
    
    func checkVisibilityOfProjectArea(projects:[String]?){
        if projects == nil {
            projectsCVHeight.constant = 0
            experienceLabel.text = "no_project".localized
            projectsCV.isHidden = true
        }
        else
        {
            initProjectCV()
        }
    }
    
}
