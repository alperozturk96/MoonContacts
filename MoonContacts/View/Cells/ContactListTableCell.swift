//
//  ContactListTableCell.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 20.10.2021.

/*
    This class responsible for adding UIButton in every table cell.
*/

//

import UIKit.UITableViewCell
import Contacts

final class ContactListTableCell: UITableViewCell {
    
    weak var delegate: ContactListProtocol?
    weak var cellContact: CNContact?
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("in_contact".localized, for: .normal)
        btn.backgroundColor = .systemIndigo
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        contentView.addSubview(button)
        
        // If contact is registered on the device, it adds action to related cellButton, so we are preventing multiple firing functions.
        button.addAction {
            if let contact = self.cellContact {
                self.delegate?.openContact(contact)
            }
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    func initContact(_ contact:CNContact){
        cellContact = contact
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
