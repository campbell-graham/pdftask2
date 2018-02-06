//
//  AllListsViewController.swift
//  CheckLists
//
//  Created by Campbell Graham on 6/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ListItem")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 64
        
        //dummy data
        lists.append(Checklist(name: "Birthdays"))
        lists.append(Checklist(name: "Groceries"))
        lists.append(Checklist(name: "Other stuff"))
        
        addChecklistBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openListDetailController))
        navigationItem.rightBarButtonItem = addChecklistBarButtonItem
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath)
        cell.textLabel!.text = lists[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = CheckListViewController(checklist: lists[indexPath.row])
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
        }
        delete.backgroundColor = .red
        return [delete, edit]
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        lists.append(checklist)
        tableView.reloadData()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        tableView.reloadData()
    }
    
    @IBAction func openListDetailController() {
        let destination = ListDetailViewController(checklist: nil)
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }

}
