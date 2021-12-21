//
//  ViewController.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 19.10.2021.
//

import Combine
import UIKit
import Contacts
import ContactsUI

class ContactListVC: BaseVC {
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet weak var employeeTableView: UITableView!
    
    let VM = ContactListVM()
    let refreshControl = UIRefreshControl()
    
    private var tallinEmployeeList:AnyCancellable?
    private var tartuEmployeeList:AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator()
        askUserPermissionToAccessContactList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConst.contractDetailSegeu {
            if let destinationVC = segue.destination as? ContactDetailVC {
                destinationVC.employee = VM.selectedEmployee
                destinationVC.contact = VM.selectedContact
            }
        }
    }
    
    func askUserPermissionToAccessContactList(){
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
      
        let contractProvider = ContractProvider.init(store: store, authorizationStatus: authorizationStatus)
        contractProvider.askUserPermissionToAccessContactList {
            self.prepareUI()
        }
    }
    
    func prepareUI(){
        VM.getContactListFromDevice()
        addPullToRefreshToEmployeeTableView()
        fetchEmployeeList()
    }
  
    @objc func refreshEmployeeTableView(_ sender: AnyObject) {
        VM.employees.removeAll()
        fetchEmployeeList()
    }
    
    func addPullToRefreshToEmployeeTableView(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshEmployeeTableView(_:)), for: .valueChanged)
        employeeTableView.addSubview(refreshControl)
    }
    
    func initEmployeeTableView(){
        employeeTableView.register(ContactListTableCell.self, forCellReuseIdentifier: VM.employeeTableViewIdentifier)
        employeeTableView.dataSource = self
        employeeTableView.delegate = self
        searchBar.delegate = self
    }
    
    func updateEmployeeTableView(){
        VM.groupContactListItems()
        initEmployeeTableView()
        searchBar.isUserInteractionEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.employeeTableView.reloadData()
            self.hideActivityIndicator()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func showErrorAlert() {
        let errorAlert = UIAlertController(title: "Error", message: "An Error occurred while fetching datas.", preferredStyle: .alert)
        
        errorAlert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] action -> Void in
            guard let strongSelf = self else {return}
            strongSelf.fetchEmployeeList()
        })
        
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    
    //MARK: API CALL
    private func fetchEmployeeList(){
        tallinEmployeeList = VM.fetchTallinEmployeeList(complicated: { [weak self] response in
            guard let self = self else { return }
            self.VM.employees = response.employees!
            self.fetchTartuEmployeeList()
        }, error: { [weak self] error in
            guard let self = self else {return}
            self.showErrorAlert()
            print("error catched at tallinEmployeeList: ",error)
        })
    }
    
    private func fetchTartuEmployeeList(){
        tartuEmployeeList = VM.fetchTartuEmployeeList(complicated: { [weak self] response in
            guard let self = self else { return }
            self.VM.employees += response.employees!
            self.updateEmployeeTableView()
        }, error: { [weak self] error in
            guard let self = self else {return}
            self.showErrorAlert()
            print("error catched at tartuEmployeeList: ",error)
        })
    }
    
}

extension ContactListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty
        {
            VM.contactList = VM.untouchedList
        }
        else
        {
            VM.contactList = VM.contactList.filter({$0.letter == searchText})
        }
        
        employeeTableView.reloadData()
    }
}

extension ContactListVC: CNContactViewControllerDelegate{
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
}

