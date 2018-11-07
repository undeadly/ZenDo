//
//  ViewController.swift
//  Todoey
//
//  Created by cory.roy on 2018-11-04.
//  Copyright © 2018 cory.roy. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray: [TodoItem] = [TodoItem]()
    
    var defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("could not add item: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        let decoder = PropertyListDecoder()
        
        do {
            let data = try? Data(contentsOf: dataFilePath!)
            self.itemArray = try decoder.decode([TodoItem].self, from: data!)
        } catch {
            print("couldn't decode \(error)")
        }
    }
    
    @IBAction func addItemTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let addPopup = UIAlertController(title: "Add some zen", message: "", preferredStyle: .alert)

        addPopup.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "I'll feel better when this down..."
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            self.itemArray.append(TodoItem(textField.text!))
            self.saveData()
        }
        
        addPopup.addAction(action)
        
        present(addPopup, animated: true, completion: nil)
    }
    //MARK - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        let currentTodoItem = itemArray[indexPath.row]
        cell!.textLabel?.text = currentTodoItem.item
        cell!.accessoryType = currentTodoItem.done ? .checkmark : .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentTodoItem = itemArray[indexPath.row]
        print(indexPath.row, currentTodoItem.item)
        currentTodoItem.done = !currentTodoItem.done
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    


}

