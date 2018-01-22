//
//  CategoryViewController.swift
//  ToDos
//
//  Created by Yanet Leon on 1/22/18.
//  Copyright © 2018 Yanet Leon. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category] ()
    
    // Singleton object to access the AppDelegate and access the container that will communicate with
    // our persistent container and do CRUD operations.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the available categories
        loadCategories()

    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    // Save Data
    func saveCategory() {
        
        do {
            try context.save()
            
        } catch {
            print("Error saving category: \(error)")
        }
        // Reload to show the list of categories with the new data.
        tableView.reloadData()
    }
    
    // Load Data
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        // Reload to show the list of categories with the new data.
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default){ (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            // Add func to save data to DB.
            self.saveCategory()
            
        }
        
        // Triggered when the user clicks the + button
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Delegate Methods
    // This triggers when we select one of the cells.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We want to trigger the segue that takes us from the ToDos TableView Controller to the Items TableView Controller.
        performSegue(withIdentifier: "goToItems" , sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This gets triggered just before we perform the segue.
        
        // Variable holding reference to the destination VC.
        let destinationVC = segue.destination as! TodoListViewController
        
        // Grab the category that corresponds to the selected cell.
        // Identifies the path for the current row that is selected.
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

}
