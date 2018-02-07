//
//  AllListsViewController.swift
//  CheckLists
//
//  Created by Campbell Graham on 6/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, CheckListViewControllerDelegate, UINavigationControllerDelegate {
    
    var lists = [Checklist]()
    var finishedLists = [Checklist]()
    var notFinishedLists = [Checklist]()
    var addChecklistBarButtonItem: UIBarButtonItem!
    
    init() {
         super.init(style: .grouped)
        self.title = "Checklists"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 64
        addChecklistBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openListDetailController))
        navigationItem.rightBarButtonItem = addChecklistBarButtonItem
        loadChecklists()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : return finishedLists.count
        case 1 : return notFinishedLists.count
        default : return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "Finished"
        }
        if (section == 1){
            return "Outstanding"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        switch indexPath.section {
        //finished
        case 0 : do {
            let list = finishedLists[indexPath.row]
            cell?.textLabel!.text = list.name
            if list.items.count == 0 {
                cell?.detailTextLabel?.text = "No items"
            } else {
                cell?.detailTextLabel?.text = "All done!"
            }
            }
        //not finished
        case 1 : do {
            let list = notFinishedLists[indexPath.row]
            let incompleteItems = list.items.filter({!$0.checked}).count
            cell?.textLabel!.text = list.name
            cell?.detailTextLabel?.text = incompleteItems > 1 ? String("\(incompleteItems) items remaining") : String("\(incompleteItems) item remaining")
            }
            
        //default to finished
        default : do {
            let list = finishedLists[indexPath.row]
            cell?.textLabel!.text = list.name
            if list.items.count == 0 {
                cell?.detailTextLabel?.text = "No items"
            } else {
                cell?.detailTextLabel?.text = "All done!"
            }
            }
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndexRow")
        UserDefaults.standard.set(indexPath.section, forKey: "ChecklistIndexSection")
        switch indexPath.section {
        case 0: do {
            let destination = CheckListViewController(checklist: finishedLists[indexPath.row])
            destination.delegate = self
            self.navigationController?.pushViewController(destination, animated: true)
        }
        case 1: do {
            let destination = CheckListViewController(checklist: notFinishedLists[indexPath.row])
            destination.delegate = self
            self.navigationController?.pushViewController(destination, animated: true)
            }
        default:
            print("well this is awkward....I couldn't find this list!")
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            let destination = ListDetailViewController(checklist: self.lists[editActionsForRowAt.row])
            destination.delegate = self
            self.navigationController?.pushViewController(destination, animated: true)
        }
        edit.backgroundColor = .lightGray
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.lists.remove(at: editActionsForRowAt.row)
            let indexPaths = [editActionsForRowAt]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            self.saveChecklists()
        }
        delete.backgroundColor = .red
        return [delete, edit]
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        lists.append(checklist)
        saveChecklists()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        saveChecklists()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.delegate = self
        let indexRow = UserDefaults.standard.integer(forKey: "ChecklistIndexRow")
        let indexSection = UserDefaults.standard.integer(forKey: "ChecklistIndexSection")
        if indexRow != -1 && indexSection != -1 && lists.count > 0{
            if indexSection == 0 {
                let destination = CheckListViewController(checklist: finishedLists[indexRow])
                navigationController?.pushViewController(destination, animated: false)
            } else if indexSection == 1 {
                let destination = CheckListViewController(checklist: notFinishedLists[indexRow])
                navigationController?.pushViewController(destination, animated: false)
            }
            else {
                print ("Well this is awkard... I couldn't find that section")
            }
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //finish lists are where there are no items left
        finishedLists = lists.filter({$0.items.count == 0})
        //lists that are not finished contain everything else
        notFinishedLists = lists.filter({!finishedLists.contains($0)})
        print(finishedLists.count)
        print(notFinishedLists.count)
    }
    
    @IBAction func openListDetailController() {
        let destination = ListDetailViewController(checklist: nil)
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding lists array")
        }
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
            }
            catch {
                print("Error decoding lists array")
            }
        }
        tableView.reloadData()
    }
    
    func CheckListViewControllerDidChange(_ controller: CheckListViewController) {
        saveChecklists()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //checks if the back button was pressed
        if viewController === self {
            UserDefaults.standard.set(-1, forKey: "ChecklistIndexRow")
            UserDefaults.standard.set(-1, forKey: "ChecklistIndexSection")
        }
    }
    
}
