//
//  TodoListViewController.swift
//  ToDos
//
//  Created by Yanet Leon on 1/20/18.
//  Copyright © 2018 Yanet Leon. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item] ()
    
    // Needed for the prepare(for segue:) method from CategoryViewController
    var selectedCategory : Category? {
        didSet{
            // This will get triggered only if the selectedCategory variable has a value assigned.
            // If we have a category then let's load the associated items.
            loadItems()
        }
    }
    
    // Path to where the data is being stored for the current app.  Keeping this just for learning purposes.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    // Using the shared singleton object to access the AppDelegate object and access the container where we will be saving our data.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        // Displaying plist document location.
        print(dataFilePath)
        
        // Note re: delegate: Added the delegate on the mainStory board by dragging the SeachBar into the "yellow" icon.
        // The ViewController.
    }
    
    //MARK: - TableView DataSource Methods
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
    
    //MARK: - TableView Delegate Methods: checkmark & cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If cell has a checkmark or not then set it to the oppossite when the cell is selected to update.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        // Order matters here! First remove from contexts and then remove from array.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
//
        saveItems()
        
        // To get the animation working when selecting and deselecting a cell.
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the + button on the UIAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            // Let's store the data in our Persistent Storage.
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
    
    // MARK: - Model Manipulation Methods
    func saveItems () {
        
        do {
            // This commits the changes to our persistent store.
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        // Refresh the view
        self.tableView.reloadData()
    }
    
    // Expects an array of type NSFetchRequest if not provided fetch all the items via Item.fetchRequest() (default).
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@ ", selectedCategory!.name!)
        
        // Using optional binding
        // If we have a predicate set then we use NSCompoundPredicate
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            // Otherwise, we will be querying using the category predicate.
            request.predicate = categoryPredicate
        }

        
        // Reading from the DB
        do {
           itemArray =  try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        // Update the tableView with the new data.
        tableView.reloadData()
    }
    
}

// MARK: - SearchBar methods
extension TodoListViewController: UISearchBarDelegate {
    
    // Delegate Method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:  NSFetchRequest<Item> = Item.fetchRequest()
        
        // Setting up the predicate to search.
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    // This method is triggered only when the text has changed and is equal to 0.
    // This logic helps us go back to the original list if we clear the search bar by clicking on the x button.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // Accessing the main thread/queue to have it process the request to dismiss the blinking cursor and the keyboard.
            // This is ran in the foreground.
            DispatchQueue.main.async {
                // This dimisses the blinking cursor on the search bar and the keyboard.
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    

}
