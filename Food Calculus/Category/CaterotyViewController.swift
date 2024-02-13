//
//  CaterotyViewController.swift
//  Food Calculus
//
//  Created by Vitaly Gromov on 03.02.2024.
//

import UIKit
import CoreData

class CaterotyViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        clearDatabase()
//        deleteAll()
        setupNavBar()
        self.tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.cellId)
        reloadContext()
        setupRefresher()
        
        
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var localCategoryArray: [CategoryItem] = []
    let refresher = UIRefreshControl()
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        localCategoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellId, for: indexPath) as? CategoryCell
        guard let cell = cell else {return UITableViewCell()}
        cell.selectionStyle = .default
        cell.accessoryType = .disclosureIndicator
        cell.setupCellConfig(text: localCategoryArray[indexPath.row].name!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = ItemsViewController()
        newVC.selectedCategory = localCategoryArray[indexPath.row]
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    // TODO: - maybe add alert for delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(localCategoryArray[indexPath.row])
            print("Category has been deleted -> ", self.localCategoryArray[indexPath.row].name ?? "Name error" )
            self.localCategoryArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveContext()
        }
    }
    func setupRefresher() {
        refresher.addTarget(self, action: #selector(addCategory), for: .valueChanged)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 0.11, green: 0.21, blue: 0.34, alpha: 0.50)]
        refresher.attributedTitle = NSAttributedString(string: "pull down to add", attributes: attributes)
        refresher.tintColor = UIColor(red: 0.11, green: 0.21, blue: 0.34, alpha: 0.50)
        refresher.bounds = CGRect(x: refresher.bounds.origin.x,
                                         y: 0,
                                         width: refresher.bounds.size.width,
                                         height: refresher.bounds.size.height)
        tableView.addSubview(refresher)
    }
    
    
    func setupNavBar() {
//        view.backgroundColor = UIColor(red: 0.95, green: 0.98, blue: 0.93, alpha: 1.00)
        let nav = self.navigationController?.navigationBar
        navigationController?.navigationBar.prefersLargeTitles = true
        nav?.topItem?.title = "Categories"
        let allRecordsButton = UIBarButtonItem(image: UIImage(systemName: "tray.full"), style: .plain, target: self, action: #selector(showAllRecords))
        allRecordsButton.tintColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addCategory))
        addButton.tintColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
        nav?.topItem?.rightBarButtonItems = [addButton, allRecordsButton]
//        nav?.standardAppearance.backgroundColor = UIColor(red: 0.95, green: 0.98, blue: 0.93, alpha: 1.00)
//        nav?.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor(red: 0.11, green: 0.21, blue: 0.34, alpha: 1.00)]
        
    }
    
    @objc func showAllRecords() {
        let itemsVC = ItemsViewController()
        itemsVC.selectedCategory = nil
        self.navigationController?.pushViewController(itemsVC, animated: true)
    }
    
    @objc func addCategory() {
        tableView.reloadData()
        refresher.endRefreshing()
        callAlert()
        if !localCategoryArray.isEmpty {
                    self.tableView.moveRow(at: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 0))
        }
    }
    
    func callAlert() {
        let alert = UIAlertController(title: "New Category", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            let newItem = CategoryItem(context: self.context)
            newItem.name = alert.textFields![0].text!
            self.localCategoryArray.append(newItem)
            self.saveContext()
        }))
        present(alert, animated: true)
    }
    
    func saveContext() {
        do {
            try context.save()
            tableView.reloadData()
            print("Categories are saved +")
        } catch {
            print("Categories are not saved -")
        }
    }
    
    func reloadContext() {
        do {
            localCategoryArray = try context.fetch(CategoryItem.fetchRequest())
            tableView.reloadData()
            print("Сategories have been reloaded +")
        } catch {
            print("Сategories have not been reloaded -")
        }
    }
    
    func checkForAllCategory() -> Bool{
        var result = false
        for i in localCategoryArray {
            if i.name == "All Records" {
                result = true
            }
        }
        return result
    }
    
    public func clearDatabase() {
        let x = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        guard let url = x.persistentStoreDescriptions.first?.url else { return }
        
        let persistentStoreCoordinator = x.persistentStoreCoordinator

         do {
             try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
             try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
         } catch {
             print("Attempted to clear persistent store: " + error.localizedDescription)
         }
    }
    func deleteAll() {
          let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = RecordItem.fetchRequest()
          let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
          _ = try? context.execute(batchDeleteRequest1)
    }

}


import SwiftUI
#Preview(body: {
    UINavigationController(rootViewController: CaterotyViewController())
})
