//
//  CaterotyViewController.swift
//  Food Calculus
//
//  Created by Vitaly Gromov on 03.02.2024.
//

import UIKit
import CoreData

//class CategoryItem {
//    var name: String = ""
//}

class CaterotyViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
    
    var localCategoryArray: [CategoryItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        localCategoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func setupNavBar() {
        let nav = self.navigationController?.navigationBar
        
        nav?.topItem?.title = "Categories"
        nav?.topItem?.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addCategory))
        
    }
    
    @objc func addCategory() {
            callAlert()
    }
    
    func callAlert() {
        let alert = UIAlertController()
        alert.addTextField { tf in
            tf.placeholder = "name?"
        }
        alert.addAction(UIAlertAction(title: "add", style: .default, handler: { _ in
            let newItem = CategoryItem(context: self.context)
            newItem.name = alert.textFields![0].text!
            self.localCategoryArray.append(newItem)
        }))
    }
    
    func saveContext() {
        do {
            try context.save()
            print("save+")
        } catch {
            print("save-")
        }
    }
    
    func reloadContext() {
        do {
            localCategoryArray = try context.fetch(CategoryItem.fetchRequest())
            print("reload+")
        } catch {
            print("reload-")
        }
    }
    

}

