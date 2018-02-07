//
//  ViewController.swift
//  CheckLists
//
//  Created by Campbell Graham on 2/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class CheckListViewController : UITableViewController, ItemDetailViewControllerDelegate {
   
    var checklist: Checklist!
    var delegate: CheckListViewControllerDelegate?
    
    init(checklist: Checklist) {
        self.checklist = checklist
        super.init(nibName: nil, bundle: nil)
        let addListItemBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem = addListItemBarButtonItem
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 64
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CheckListItem")
        tableView.reloadData()
        title = checklist.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
            delegate?.passMessageToSave(self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            let destination = ItemDetailViewController(item: self.checklist.items[editActionsForRowAt.row])
            destination.delegate = self
            self.navigationController?.pushViewController(destination, animated: true)
        }
        edit.backgroundColor = .lightGray
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.checklist.items.remove(at: editActionsForRowAt.row)
            let indexPaths = [editActionsForRowAt]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        delete.backgroundColor = .red
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: CheckListItem) {
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: CheckListItem) {
        let label = cell.textLabel!
        label.text = item.text
    }
    
    @IBAction func addItem() {
        let destination = ItemDetailViewController()
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem) {
        checklist.items.append(item)
        delegate?.passMessageToSave(self)
        tableView.reloadData()
    }
    
    func itemDetailViewControllerDidFinishEditing(_ controller: ItemDetailViewController) {
        delegate?.passMessageToSave(self)
        tableView.reloadData()
    }
}

protocol CheckListViewControllerDelegate: class {
    func passMessageToSave(_ controller: CheckListViewController)
}
