//
//  ViewController.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 19.10.2021.
//

import Combine
import UIKit

class ContactListVC: BaseVC {
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet weak var employeeTableView: UITableView!
    
    let VM = ContactListVM()
    let refreshControl = UIRefreshControl()
    
    private var tallinEmployeeList:AnyCancellable?
    private var tartuEmployeeList:AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.contactListToContactDetail {
            if let destinationVC = segue.destination as? ContactDetailVC {
                destinationVC.employee = VM.selectedEmployee
                destinationVC.contact = VM.selectedContact
            }
        }
    }
    
    func setupUI(){
        addPullToRefreshToEmployeeTableView()
        fetchEmployeeList()
    }
  
    @objc func refreshEmployeeTableView(_ sender: AnyObject) {
        VM.employees.removeAll()
        fetchEmployeeList()
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
        VM.prepareContactList()
        initEmployeeTableView()
        searchBar.isUserInteractionEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.employeeTableView.reloadData()
            self.hideActivityIndicator()
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
        showActivityIndicator()
        let publisher = API.tallinEmployeeList()
        
        tallinEmployeeList = VM.fetchTallinEmployeeList(publisher: publisher, complicated: { [weak self] response in
            guard let self = self else { return }
            guard let employees = response.employees else { return }
            self.VM.employees = employees
            self.fetchTartuEmployeeList()
        }, error: { [weak self] error in
            guard let self = self else {return}
            self.hideActivityIndicator()
            self.showErrorAlert()
            print("error catched at tartuEmployeeList: ",error)
        })
    }
    
    private func fetchTartuEmployeeList(){
        let publisher = API.tartuEmployeeList()
        
        tartuEmployeeList = VM.fetchTartuEmployeeList(publisher: publisher, complicated: { [weak self] response in
            guard let self = self else { return }
            guard let employees = response.employees else { return }
            self.VM.employees += employees
            self.updateEmployeeTableView()
        }, error: { [weak self] error in
            guard let self = self else {return}
            self.showErrorAlert()
            self.hideActivityIndicator()
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
