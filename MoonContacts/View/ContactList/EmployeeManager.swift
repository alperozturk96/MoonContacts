//
//  EmployeeManager.swift
//  MoonContacts
//
//  Created by Alper Öztürk on 22.12.2021.
//

final class EmployeeManager {
    var employees:[Employee]
    
    required init(employees: [Employee]) {
        self.employees = employees
    }
    
    func findSelectedEmployee(fullName:String) -> Employee? {
        for i in 0..<employees.count{
            if let empfullName = employees[i].fullName(){
                if fullName == empfullName
                {
                    return employees[i]
                }
            }
        }
        
        return nil
    }
    
    func getUniqueEmployees() -> [String] {
        var names = [String]()
        
        for i in 0..<employees.count {
            if let fullName = employees[i].fullName(){
                names.append(fullName)
            }
        }
        
        return names.uniqued()
    }
}
