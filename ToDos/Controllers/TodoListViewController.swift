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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Displaying plist document location.
        print(dataFilePath!)

        // Load the items from the Items.plist
        loadItems()
        
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
        
        saveItems()
        
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
            
            // Using the encoder to persist data.
            self.saveItems()

        }

        // Triggered when the user clicks the + button.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    // MARK - Model Manipulation Methods
    func saveItems () {
        // Using the encoder to persist data.
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        // Refresh the view
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data.init(contentsOf: dataFilePath!) {
            //
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding itemArray: \(error)")
            }
        }
    }
    
}

