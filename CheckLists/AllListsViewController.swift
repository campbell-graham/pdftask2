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
    var addChecklistBarButtonItem: UIBarButtonItem!
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let list = lists[indexPath.row]
        cell?.textLabel!.text = list.name
        let incompleteItems = list.items.filter({!$0.checked}).count
        if list.items.count == 0 {
            cell?.detailTextLabel?.text = "No items"
        } else if incompleteItems == 0 {
            cell?.detailTextLabel?.text = "All done!"
        } else {
            cell?.detailTextLabel?.text = incompleteItems > 1 ? String("\(incompleteItems) items remaining") : String("\(incompleteItems) item remaining")
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        let destination = CheckListViewController(checklist: lists[indexPath.row])
        destination.delegate = self
        self.navigationController?.pushViewController(destination, animated: true)
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
        tableView.reloadData()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        saveChecklists()
        tableView.reloadData()
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.delegate = self
        let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        if index != -1 && lists.count > 0{
            let destination = CheckListViewController(checklist: lists[index])
            navigationController?.pushViewController(destination, animated: false)
        }
        tableView.reloadData()
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
            UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
        }
    }

}
