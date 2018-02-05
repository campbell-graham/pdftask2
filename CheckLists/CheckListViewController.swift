//
//  ViewController.swift
//  CheckLists
//
//  Created by Campbell Graham on 2/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class CheckListViewController : UITableViewController {
    
    var items: [CheckListItem]
    
    init() {
       
        items = [CheckListItem]()
        
        items.append(CheckListItem(text: "Some text 0", checked: false))
        items.append(CheckListItem(text: "Some text 1", checked: false))
        items.append(CheckListItem(text: "Some text 2", checked: false))
        items.append(CheckListItem(text: "Some text 3", checked: false))
        items.append(CheckListItem(text: "Some text 4", checked: false))
        
        super.init(nibName: nil, bundle: nil)
        
        let addListItemBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem = addListItemBarButtonItem
        
        self.title = "Items"
        
        
        
        //hides the excess rows of the table view
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CheckListItem")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath)
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: CheckListItem) {
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
//        let newRowIndex = items.count
//        items.append(CheckListItem(text: "sdofjsdnckds", checked: false))
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
        let destination = AddItemViewController()
        navigationController?.pushViewController(destination, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
