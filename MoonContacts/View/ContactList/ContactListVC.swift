//
//  ContactListVC.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 23.12.2021.
//

import Combine
import UIKit
import Contacts

final class ContactListVC: BaseVC {
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet weak var employeeTableView: UITableView!
    
    let contactListVM = ContactListVM()
    let contactListProviderVM = ContactListProviderVM()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.contactListToContactDetail {
            if let destinationVC = segue.destination as? ContactDetailVC {
                destinationVC.employee = contactListVM.selectedEmployee
                destinationVC.contact = contactListVM.selectedContact
            }
        }
    }
    
    func setupUI(){
        observeLoadingIndicator()
        addPullToRefreshToEmployeeTableView()
        fetchEmployeeList()
    }
    
    @objc func refreshEmployeeTableView(_ sender: AnyObject) {
        contactListVM.employees.removeAll()
        fetchEmployeeList()
    }
    
    //Note: This is FirstParty Solution RxSwift provides similar function also.
    func observeLoadingIndicator(){
        contactListVM.loadingIndicator.bind { [weak self] loading in
            guard let self = self else { return }
            if loading {
                self.showActivityIndicator()
            }
            else
            {
                self.hideActivityIndicator()
            }
        }
    }
    
    func addPullToRefreshToEmployeeTableView(){
        refreshControl.attributedTitle = NSAttributedString(string: "pull_to_refresh".localized)
        refreshControl.addTarget(self, action: #selector(refreshEmployeeTableView(_:)), for: .valueChanged)
        employeeTableView.addSubview(refreshControl)
    }
    
    func initEmployeeTableView(){
        employeeTableView.register(ContactListTableCell.self, forCellReuseIdentifier: CellIdentifiers.employeeTableViewIdentifier)
        employeeTableView.dataSource = self
        employeeTableView.delegate = self
        searchBar.delegate = self
    }
    
    func updateEmployeeTableView(){
        contactListVM.prepareContactList()
        initEmployeeTableView()
        searchBar.isUserInteractionEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.employeeTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func showErrorAlert() {
        let errorAlert = UIAlertController(title: "error".localized, message: "error_message".localized, preferredStyle: .alert)
        
        errorAlert.addAction(UIAlertAction(title: "retry".localized, style: .default) { [weak self] action -> Void in
            guard let self = self else { return }
            self.fetchEmployeeList()
        })
        
        errorAlert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    private func fetchEmployeeList(){
        let publisher = API.tallinEmployeeList()
        
        contactListProviderVM.fetchTallinEmployeeList(publisher) { [weak self] employeeList in // weak reference usage for preventing memory leak and help ARC.
            guard let self = self else { return }
            guard let employees = employeeList.employees else { return }
            self.contactListVM.employees = employees
            self.fetchTartuEmployeeList()
        } onFailure: { [weak self] error in
            guard let self = self else {return}
            self.contactListVM.loadingIndicator.value = false
            self.showErrorAlert()
            print("error catched at tallinEmployeeList: ",error)
        }
    }
    
    private func fetchTartuEmployeeList(){
        let publisher = API.tartuEmployeeList()
        
        contactListProviderVM.fetchTartuEmployeeList(publisher) { [weak self] employeeList in
            guard let self = self else { return }
            guard let employees = employeeList.employees else { return }
            self.contactListVM.employees += employees
            self.updateEmployeeTableView()
            self.contactListVM.loadingIndicator.value = false
        } onFailure: { [weak self] error in
            guard let self = self else {return}
            self.contactListVM.loadingIndicator.value = false
            self.showErrorAlert()
            print("error catched at tartuEmployeeList: ",error)
        }
    }
}

extension ContactListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty
        {
            contactListVM.contactList = contactListVM.untouchedList
        }
        else
        {
            contactListVM.contactList = contactListVM.contactList.filter({
                return $0.names.joined().contains(searchText)
            })
        }
        
        employeeTableView.reloadData()
    }
}


extension ContactListVC: ContactListProtocol{
    func openContact(_ contact: CNContact) {
        self.openNativeContactDetailScreen(contact)
    }
}
