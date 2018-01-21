//
//  TodoListViewController.swift
//  ToDos
//
//  Created by Yanet Leon on 1/20/18.
//  Copyright © 2018 Yanet Leon. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Finish Swift Projects", "Make Dinner", "Watch Movies with Abram"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - TableView DataSource Methods
    // How many cells are we going to need?
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemArray.count
    }

    // How should I create each cell?
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods: checkmark & cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the + button on the UIAlert
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()

        }

        // Triggered when the user clicks the + button.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("addTextField triggered!")

        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    
    
}

