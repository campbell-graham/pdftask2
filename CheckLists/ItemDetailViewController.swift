//
//  TableTableViewController.swift
//  CheckLists
//
//  Created by Campbell Graham on 5/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemNameTextField : UITextField!
    var doneBarButtonItem: UIBarButtonItem!
    var item: CheckListItem?
    
    
    init(item : CheckListItem? = nil) {
        super.init(style: .grouped)
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        doneBarButtonItem.isEnabled = false
        self.item = item
        self.title = item == nil ? "Add Item" : "Edit Item"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        itemNameTextField.becomeFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        itemNameTextField = UITextField(frame: CGRect(x: 10, y: 0, width: cell.bounds.width - 10, height: cell.bounds.height))
        itemNameTextField.delegate = self
        itemNameTextField.placeholder = "Enter reminder text here"
        itemNameTextField.font = UIFont.systemFont(ofSize: 17)
        cell.contentView.addSubview(itemNameTextField)
        itemNameTextField.text = item?.text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    @IBAction func done() {
        if item != nil {
            item?.text = itemNameTextField.text!
        }
        else {
            delegate?.itemDetailViewController(self, didFinishAdding: CheckListItem(text: itemNameTextField.text!, checked: false))
        }
          navigationController?.popViewController(animated: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = itemNameTextField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButtonItem.isEnabled = !newText.isEmpty
        
        return true
    }
}

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem)
}
