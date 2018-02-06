//
//  AllListsViewController.swift
//  CheckLists
//
//  Created by Campbell Graham on 6/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    var lists = [Checklist]()
    
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


}
