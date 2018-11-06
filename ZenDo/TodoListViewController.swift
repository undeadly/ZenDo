//
//  ViewController.swift
//  Todoey
//
//  Created by cory.roy on 2018-11-04.
//  Copyright © 2018 cory.roy. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray : [String] = []
    
    var defaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        itemArray = defaults.array(forKey: "Todos") as! [String]
    }
    
    @IBAction func addItemTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let addPopup = UIAlertController(title: "Add some zen", message: "", preferredStyle: .alert
        )

        addPopup.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "I'll feel better when this down..."
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "Todos")
            
            self.tableView.reloadData()
        }
        
        
        addPopup.addAction(action)
        
        present(addPopup, animated: true, completion: nil)
    }
    //MARK - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        cell!.textLabel?.text = itemArray[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row, itemArray[indexPath.row])
        
        let currentCell = tableView.cellForRow(at: indexPath)
        
        if currentCell?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

