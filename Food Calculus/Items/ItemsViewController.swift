//
//  ItemsViewController.swift
//  Food Calculus
//
//  Created by Vitaly Gromov on 05.02.2024.
//

import Foundation
import UIKit
import CoreData


class ItemsViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let refresher = UIRefreshControl()
    var localItemsArray: [RecordItem] = []
    var selectedCategory: CategoryItem? {
        didSet {
            print("Category selected -> ", selectedCategory?.name ?? "ALL")
            reloadContext(sortBy: .dateDescending)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupRefresher()
    }
    
    func setupRefresher() {
        refresher.addTarget(self, action: #selector(addNewRecord), for: .valueChanged)
        tableView.addSubview(refresher)
    }
    
    func setupNavBar() {
        view.backgroundColor = .white
        navigationItem.title = selectedCategory?.name ?? "All Records"
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addNewRecord))
        addButton.tintColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(callFilter))
        filterButton.tintColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
        let counterView = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        counterView.isEnabled = false
        counterView.title = String(self.localItemsArray.count)
        
        let itemsView = [addButton, filterButton]
        let allRecordsView = [counterView, filterButton]
        
        navigationItem.rightBarButtonItems = selectedCategory == nil ? allRecordsView : itemsView
//        navigationItem.standardAppearance?.backgroundColor = UIColor(red: 0.95, green: 0.98, blue: 0.93, alpha: 1.00)
        navigationItem.standardAppearance?.backgroundColor = .white
        navigationItem.standardAppearance?.titleTextAttributes = [.foregroundColor: UIColor(red: 0.11, green: 0.21, blue: 0.34, alpha: 1.00)]
        
    }
    
    @objc func addNewRecord() {
        refresher.endRefreshing()
        if !localItemsArray.isEmpty {
                    self.tableView.moveRow(at: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 0))
        }
        callDetailsSheet()
    }
    
    @objc func callFilter() {
//        print("FILTER ALERT")
        callFilterAlert()
    }
    
    func callFilterAlert() {
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Date Descending", style: .default, handler: { _ in
            self.reloadContext(sortBy: .dateDescending)
        }))
        alert.addAction(UIAlertAction(title: "Date Ascending", style: .default, handler: { _ in
            self.reloadContext(sortBy: .dateAscending)
        }))
        alert.addAction(UIAlertAction(title: "Cost Descending", style: .default, handler: { _ in
            self.reloadContext(sortBy: .costDescending)
        }))
        alert.addAction(UIAlertAction(title: "Cost Ascending", style: .default, handler: { _ in
            self.reloadContext(sortBy: .costAscending)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func callDetailsSheet() {
        let newDetailSheet = DetailSheetViewController(deatilSheetParentCategory: selectedCategory)
        newDetailSheet.delegate = self
        newDetailSheet.modalPresentationStyle = .formSheet
        present(newDetailSheet, animated: true) {
//            print("sheet opened")
        }
    }
    

}
 
// MARK: - CoreData
extension ItemsViewController {
        func saveContext() {
            do {
                try context.save()
                tableView.reloadData()
                print("Records are saved +")
            } catch {
                print("Records are not saved -")
            }
        }
    
    enum SortBy {
        case dateAscending
        case dateDescending
        case costAscending
        case costDescending
    }
        
    func reloadContext(sortBy: SortBy = .dateDescending) {
            do {
                print("Reload records for category -> ", selectedCategory?.name ?? "All")
                
//                // db corrector
//                for i in localItemsArray {
//                    i.costPerGr = i.cost / i.weight
//                    i.costPerKg = i.costPerGr * 1000
//                }
                
                let fetch = RecordItem.fetchRequest()
                let dateAscendingSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
                let dateDescendingSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                let costAscendingSortDescriptor = NSSortDescriptor(key: "costPerGr", ascending: true)
                let costDescendingDescriptor = NSSortDescriptor(key: "costPerGr", ascending: false)
                
                switch sortBy {
                case .dateAscending: fetch.sortDescriptors = [dateAscendingSortDescriptor]
                case .dateDescending: fetch.sortDescriptors = [dateDescendingSortDescriptor]
                case .costAscending: fetch.sortDescriptors = [costAscendingSortDescriptor]
                case .costDescending: fetch.sortDescriptors = [costDescendingDescriptor]
                }
                
                // record already exists
                if let selectedCategory = selectedCategory {
                    let parentCategoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory.name)
                    fetch.predicate = parentCategoryPredicate
                }
                localItemsArray = try context.fetch(fetch)
                print(localItemsArray.count)
                tableView.reloadData()
            } catch {
                print("Reload records fail -")
            }
        }
}
    
 // MARK: - DetailSheetViewControllerDelegate
    extension ItemsViewController: DetailSheetViewControllerDelegate {
        func sheetDismiss() {
            print("Records reloaded by detail sheet delegate")
            self.dismiss(animated: true)
            reloadContext()
        }
    }

// MARK: - TableView Controls
extension ItemsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localItemsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseId)
        if selectedCategory == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseId, for: indexPath) as? ItemCell
            guard let cell = cell else {return UITableViewCell()}
            cell.showCategory = true
            cell.recordItem = localItemsArray[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseId, for: indexPath) as? ItemCell
            guard let cell = cell else {return UITableViewCell()}
            cell.recordItem = localItemsArray[indexPath.row]
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCategory = selectedCategory else {
            print("Current category ALL")
            let editDetailsView = DetailSheetViewController(deatilSheetParentCategory: localItemsArray[indexPath.row].parentCategory)
            editDetailsView.recordingItem = localItemsArray[indexPath.row]
            editDetailsView.delegate = self
            present(editDetailsView, animated: true)
            return
        }
        let editDetailsView = DetailSheetViewController(deatilSheetParentCategory: selectedCategory)
        editDetailsView.recordingItem = localItemsArray[indexPath.row]
        editDetailsView.delegate = self
        present(editDetailsView, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(localItemsArray[indexPath.row])
            self.localItemsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            print("Record has been deleted")
            saveContext()
        }
    }
}

import SwiftUI

#Preview(body: {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let itemsVC = ItemsViewController()
    
    let categoryItem = CategoryItem(context: context)
    categoryItem.name = "Apples"
    itemsVC.selectedCategory = categoryItem
    
    let record = RecordItem(context: context)
    record.name = "Gold Apples"
    record.cost = 250
    record.weight = 500
    record.note = "From Wallmart"
    record.timeStamp = Date()
    itemsVC.localItemsArray = [record]
    
    let nvc = UINavigationController(rootViewController: itemsVC)
    nvc.navigationBar.prefersLargeTitles = true
    
    return nvc
})
