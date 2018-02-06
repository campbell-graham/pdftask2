//
//  ListDetailViewController.swift
//  CheckLists
//
//  Created by Campbell Graham on 6/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: ListDetailViewControllerDelegate?
    var listNameTextField : UITextField!
    var doneBarButtonItem: UIBarButtonItem!
    var checklist: Checklist?
    
    init(checklist: Checklist? = nil) {
        super.init(style: .grouped)
        self.checklist = checklist
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        doneBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = doneBarButtonItem
       
        if checklist != nil {
            title = "Edit Checklist"
            doneBarButtonItem.isEnabled = true
        } else {
            title = "New Checklist"
        }
    }
    
    @IBAction func done() {
        if checklist != nil {
            checklist?.name = listNameTextField.text!
            delegate?.listDetailViewController(self, didFinishEditing: checklist!)
        } else {
            let newCheckList = Checklist(name: listNameTextField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: newCheckList)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButtonItem.isEnabled = !newText.isEmpty
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        listNameTextField = UITextField(frame: CGRect(x: 10, y: 0, width: cell.bounds.width - 10, height: cell.bounds.height))
        listNameTextField.delegate = self
        listNameTextField.placeholder = "Enter list name here"
        listNameTextField.font = UIFont.systemFont(ofSize: 17)
        cell.contentView.addSubview(listNameTextField)
        listNameTextField.text = checklist?.name
        return cell
    }

}

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

