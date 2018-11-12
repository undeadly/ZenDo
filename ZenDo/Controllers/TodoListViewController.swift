//
//  ViewController.swift
//  Zendo
//
//  Created by cory.roy on 2018-11-04.
//  Copyright © 2018 cory.roy. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var items: Results<TodoItem>?
    let realm = try! Realm()
    
    var category: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        print(FileManager.default.urls(for: .documentDirectory,
                                       in: .userDomainMask))
        print(category ?? "no Category")
        loadData()
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
            
            if let currentCategory = self.category {
                do {
                    try self.realm.write {
                        let newItem = TodoItem()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    print("error saving context: \(error)")
                }
                
                self.tableView.reloadData()
            }
        }
        
        addPopup.addAction(action)
        
        present(addPopup, animated: true, completion: nil)
    }
    //MARK - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let currentTodoItem = items?[indexPath.row] {
            cell.textLabel?.text = currentTodoItem.title
            cell.accessoryType = currentTodoItem.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentTodoItem = items?[indexPath.row] {
            do {
                print(indexPath.row, currentTodoItem.title, currentTodoItem.done)
                try realm.write {
                    currentTodoItem.done = !currentTodoItem.done
                }
                tableView.reloadData()
            } catch {
                print("error updating item in realm: \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func loadData(_ filterString: String = "") {
        let cleanedFilterString = filterString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", filterString)
        
        if cleanedFilterString.count > 0 {
            items = category?.items.filter(titlePredicate).sorted(byKeyPath: "createdAt", ascending: true)
        } else {
            items = category?.items.sorted(byKeyPath: "createdAt", ascending: true)
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            if let categoryForDeletion = self.items?[indexPath.row] {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
                
                print("Item deleted")
                //  self.tableView.reloadData()
                // handle action by updating model with deletion
            }
        } catch {
            print("Error deleting category")
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    // This function maybe unneccesary now
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
