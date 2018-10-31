//
//  ViewController.swift
//  yuluTest
//
//  Created by Deepakraj Murugesan on 31/10/18.
//  Copyright © 2018 Noticeboard. All rights reserved.
//

import UIKit

class PersonsViewController: UIViewController {
    @IBOutlet weak var emptyViewBLabel: UILabel!
    @IBOutlet weak var emptyViewALabel: UILabel!
    @IBOutlet weak var tableViewB: UITableView!
    @IBOutlet weak var tableViewA: UITableView!
    @IBOutlet weak var viewB: UIView!
    @IBOutlet weak var viewA: UIView!
    var personList: [[String: [String: String]]]?
    var personListForViewA = [[String: [String: String]]]()
    var personListForViewB = [[String: [String: String]]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveToJsonFile()
        retrieveFromJsonFile()
    }
    
    //MARK:- SAVE JSON
    func saveToJsonFile() {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Persons.json")
        
        let personArray =  [["person": ["name": "1"]], ["person": ["name": "2"]],["person": ["name": "3"]],["person": ["name": "4"]],["person": ["name": "5"]],["person": ["name": "6"]],["person": ["name": "7"]],["person": ["name": "8"]],["person": ["name": "9"]],["person": ["name": "10"]],["person": ["name": "11"]],["person": ["name": "12"]],["person": ["name": "13"]],["person": ["name": "14"]],["person": ["name": "15"]],["person": ["name": "16"]],["person": ["name": "17"]],["person": ["name": "18"]],["person": ["name": "19"]],["person": ["name": "20"]],["person": ["name": "21"]],["person": ["name": "22"]],["person": ["name": "23"]],["person": ["name": "24"]],["person": ["name": "25"]],["person": ["name": "26"]],["person": ["name": "26"]],["person": ["name": "27"]],["person": ["name": "28"]],["person": ["name": "29"]],["person": ["name": "30"]],["person": ["name": "31"]],["person": ["name": "32"]],["person": ["name": "33"]],["person": ["name": "34"]],["person": ["name": "35"]],["person": ["name": "36"]],["person": ["name": "37"]],["person": ["name": "38"]],["person": ["name": "39"]],["person": ["name": "40"]],["person": ["name": "41"]],["person": ["name": "42"]],["person": ["name": "43"]]]
        
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: personArray, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    //MARK:- READ FROM JSON
    /*
     Content of Persons.json file:
     [{"person":{"name":"1"}},{"person":{"name":"2"}}]
     */
    func retrieveFromJsonFile() {
        // Get the url of Persons.json in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Persons.json")
        
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: [String: String]]] else { return }
            DispatchQueue.global(qos: .background).async {
                self.personList = personArray
                self.formTableViewDataSource()
            }
        } catch {
            print(error)
        }
    }
    
    //MARK- Forming Data source
    fileprivate func formTableViewDataSource(){
        if let personList = personList{
            if personList.count > Constants.tableViewMaxCountForA{
                self.personListForViewA = Array(personList[0...19])
                self.personListForViewB = Array(personList.dropFirst(Constants.tableViewMaxCountForA))
                //UI Api should only be called with main thread
                DispatchQueue.main.async {
                    self.loadTableView()
                }
            }else{
                self.personListForViewA = personList
                //UI Api should only be called with main thread
                DispatchQueue.main.async {
                    self.loadTableView()
                }
            }
        }
    }
    
    //MARK:- Load TableView
    fileprivate func loadTableView(){
        //For tableview A
        if let personList = personList{
            if personList.count > Constants.tableViewMaxCountForA{
                //For tableview B
                loadListForViewA()
                //For tableview B
                loadListForViewB()
            }else{
                //For tableview A only only because count is only 20
               loadListForViewA()
            }
        }
    }
    
    fileprivate func loadListForViewA(){
        if personListForViewA.count > 0{
            self.emptyViewALabel.isHidden = true
            self.tableViewA.isHidden = false
            self.tableViewA.tableFooterView = UIView()
            self.tableViewA.delegate = self
            self.tableViewA.dataSource = self
            self.tableViewA.reloadData()
        }else{
            //show empty page text
            self.emptyViewALabel.isHidden = false
            self.tableViewA.isHidden = true
        }
    }
    
    fileprivate func loadListForViewB(){
        if personListForViewB.count > 0{
            self.emptyViewBLabel.isHidden = true
            self.tableViewB.isHidden = false
            self.tableViewB.tableFooterView = UIView()
            self.tableViewB.delegate = self
            self.tableViewB.dataSource = self
            self.tableViewB.reloadData()
        }else{
            //show empty page text
            self.emptyViewBLabel.isHidden = false
            self.tableViewB.isHidden = true
        }
    }

}

//MARK:- TableView Data Source
extension PersonsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return personListForViewA.count
        }else{
            return personListForViewB.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName.viewLayoutForA, for: indexPath) as? ViewPersonListALayout {
                let name = self.personListForViewA[indexPath.row]["person"]?["name"]
                cell.setDataToCell(name: name ?? "default")
                cell.selectionStyle = .none
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName.viewLayoutForB, for: indexPath) as? ViewPersonListBLayout {
                let name = self.personListForViewB[indexPath.row]["person"]?["name"]
                cell.setDataToCell(name: name ?? "default")
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
}
