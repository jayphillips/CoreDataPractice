//
//  CategoryVC.swift
//  CoreData Practice
//
//  Created by Jay Phillips on 6/20/19.
//  Copyright © 2019 Jay Phillips. All rights reserved.
//

import UIKit
import CoreData
// Defining the persistent container to save to and load from CoreData.
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class CategoryVC: UIViewController {
    //Create an empty array of categories of type Category from the CoreData model.
    var categories = [Category]()

    @IBOutlet weak var categoryTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Define the tableview datasource and delegate.
        categoryTblView.dataSource = self
        categoryTblView.delegate = self
        
        loadCategory()
        
    }

    @IBAction func addCategoryBtnPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            let newCategory = Category(context: context)
            newCategory.categoryTitle = textField.text!
            self.categories.append(newCategory)
            self.saveCategory()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error.localizedDescription)")
        }
        self.categoryTblView.reloadData()
    }
    
    func loadCategory(for request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading category \(error.localizedDescription)")
        }
    }
    
}
//MARK: - TableView Methods
extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = categoryTblView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            let category = categories[indexPath.row]
            cell.categoryCellLbl.text = category.categoryTitle
            return cell
        } else {
            return CategoryCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            context.delete(self.categories[indexPath.row])
            self.categories.remove(at: indexPath.row)
            self.saveCategory()
            self.categoryTblView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    
}
