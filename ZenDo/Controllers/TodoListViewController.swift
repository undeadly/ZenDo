//
//  ViewController.swift
//  Todoey
//
//  Created by cory.roy on 2018-11-04.
//  Copyright © 2018 cory.roy. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray: [TodoItem] = [TodoItem]()
    
    var category: Category? {
        didSet {
            loadData()
        }
    }
    
    //var defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory,
                                       in: .userDomainMask))
        print(category)
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
            
            let newItem = TodoItem(context: self.context)
            newItem.title = textField.text!
            newItem.parentCategory = self.category
            self.itemArray.append(newItem)
            self.saveData()
        }
        
        addPopup.addAction(action)
        
        present(addPopup, animated: true, completion: nil)
    }
    //MARK - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        let currentTodoItem = itemArray[indexPath.row]
        cell!.textLabel?.text = currentTodoItem.title
        cell!.accessoryType = currentTodoItem.done ? .checkmark : .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentTodoItem = itemArray[indexPath.row]
        print(indexPath.row, currentTodoItem.title)
        currentTodoItem.done = !currentTodoItem.done
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - data manipulation methods
    func saveData() {
        do {
            try context.save()
        } catch {
            print("error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(_ filterString: String = "") {
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        do {
            let cleanedFilterString = filterString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", filterString)
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
            
            if cleanedFilterString.count > 0 {
                let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [titlePredicate, categoryPredicate])
                request.predicate = andPredicate
            } else {
                request.predicate = categoryPredicate
            }
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            try itemArray = context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching data from context")
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

