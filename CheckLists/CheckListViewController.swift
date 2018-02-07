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
    var noItemsLabel = UILabel()
    
    
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
        
        noItemsLabel.text = "No Items!"
        noItemsLabel.tag = 1
        noItemsLabel.textAlignment = .center
        if checklist.items.count == 0 {
            view.addSubview(noItemsLabel)
            
            noItemsLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([NSLayoutConstraint(item: noItemsLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                                 NSLayoutConstraint(item: noItemsLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                                 NSLayoutConstraint(item: noItemsLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50),
                                 NSLayoutConstraint(item: noItemsLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
                                 ])
        }
        
        
        
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
            delegate?.CheckListViewControllerDidChange(self)
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
            self.delegate?.CheckListViewControllerDidChange(self)
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
        if let viewToRemove = view.viewWithTag(1) {
            viewToRemove.removeFromSuperview()
        }
        delegate?.CheckListViewControllerDidChange(self)
        tableView.reloadData()
    }
    
    func itemDetailViewControllerDidFinishEditing(_ controller: ItemDetailViewController) {
        delegate?.CheckListViewControllerDidChange(self)
        tableView.reloadData()
    }
}

protocol CheckListViewControllerDelegate: class {
    func CheckListViewControllerDidChange(_ controller: CheckListViewController)
}
