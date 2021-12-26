//
//  ProjectCell.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 19.10.2021.
//

import UIKit.UICollectionViewCell

final class ProjectCell: UICollectionViewCell {
    
    let projectTitle: UILabel = {
        let title = UILabel(frame: CGRect.zero)
        title.backgroundColor = .systemIndigo
        title.layer.cornerRadius = 8
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        
        contentView.addSubview(projectTitle)
        
        projectTitle.translatesAutoresizingMaskIntoConstraints = false
        projectTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        projectTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        projectTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        projectTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    func setCell(title:String){
        projectTitle.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
