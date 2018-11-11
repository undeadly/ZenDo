//
//  CategoryViewController.swift
//  ZenDo
//
//  Created by cory.roy on 2018-11-07.
//  Copyright © 2018 cory.roy. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var itemArray: Results<Category>?

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory,
                                       in: .userDomainMask))
        loadData()
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let addPopup = UIAlertController(title: "Another ripple", message: "Add calming category", preferredStyle: .alert)
        
        addPopup.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Another part of my life falls into place ..."
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            let category = Category()
            category.name = textField.text!
            self.save(category: category)
        }
        
        addPopup.addAction(action)
        
        present(addPopup, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray?.count ?? 1
    }
    
    //MARK - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        let category = itemArray?[indexPath.row]
        cell!.textLabel?.text = category?.name ?? "No Categorie added yet"
        return cell!
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCategory = itemArray?[indexPath.row]
        print(indexPath.row, currentCategory?.name)
        // go to itemlist
        performSegue(withIdentifier: "goToItems", sender: currentCategory)
        tableView.deselectRow(at: indexPath, animated: true)
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "goToItems") {
            let destinationVC = segue.destination as! TodoListViewController
            destinationVC.category = sender as? Category
        }
    }

    
    //MARK: - data manipulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(_ filterString: String = "") {
        itemArray = realm.objects(Category.self)
    }

}
