//
//  TodoListViewController.swift
//  ToDos
//
//  Created by Yanet Leon on 1/20/18.
//  Copyright © 2018 Yanet Leon. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item] ()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Finish Swift Projects"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "HIT Training"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Mountain Biking"
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "Prepare and have dinner"
        itemArray.append(newItem4)
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    //MARK - TableView DataSource Methods
    // How many cells are we going to need?
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemArray.count
    }

    // How should I create each cell?
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Using the ternary operator to reduce the lines of code - less if statements.
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
  
        return cell
    }
    
    //MARK - TableView Delegate Methods: checkmark & cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If cell has a checkmark or not then set it to the oppossite when the cell is selected to update.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        // To get the checkmarks to show properly based on the logic above.
        tableView.reloadData()
        
        // To get the animation working when selecting and deselecting a cell.
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the + button on the UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            // Adding data to defaults to persist data.  This gets saved on plist files
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
                        
            // Refresh the view
            self.tableView.reloadData()

        }

        // Triggered when the user clicks the + button.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    
    
}

