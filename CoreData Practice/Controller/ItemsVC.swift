//
//  ItemsVC.swift
//  CoreData Practice
//
//  Created by Jay Phillips on 6/21/19.
//  Copyright © 2019 Jay Phillips. All rights reserved.
//

import UIKit
import CoreData

//let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class ItemsVC: UIViewController {
    @IBOutlet weak var itemTblView: UITableView!
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTblView.dataSource = self
        itemTblView.delegate = self

        
    }
    
    //MARK: - CoreData Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving item \(error.localizedDescription)")
        }
    }
    
    func loadItems(for request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching item \(error.localizedDescription)")
        }
    }

}

extension ItemsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = itemTblView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemCell {
            let item = items[indexPath.row]
            cell.itemLbl.text = item.itemTitle
            cell.qtyLbl.text = "\(item.itemQty)"
            cell.priceLbl.text = "\(item.itemPrice)"
            return cell
        } else {
            return ItemCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        <#code#>
//    }
}
