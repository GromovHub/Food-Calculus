//
//  ItemCell.swift
//  Food Calculus
//
//  Created by Vitaly Gromov on 11.02.2024.
//

import Foundation
import UIKit
import CoreData

class ItemCell: UITableViewCell {
    
    
    static let reuseId = "ItemCell"
    
//            """
//    name: \(dataForCell.name!)
//    cost: \(String(format: "%.2f", dataForCell.cost))
//    weight g: \(String(format: "%.0f", dataForCell.weight))
//    date: \(dataForCell.timeStamp!.moscowTimeDateFormatter())
//    note: \(String(describing: dataForCell.note ?? ""))
//    rub per g: \(String(format: "%.2f", dataForCell.cost / dataForCell.weight))
//    rub per kg: \(String(format: "%.2f", dataForCell.cost / dataForCell.weight * 1000))
//    """
    var recordItem: RecordItem? {
        didSet {
            setupCell()
        }
    }
    
    let nameLabael = UILabel()
    let costLabel = UILabel()
    let weightLabel = UILabel()
    let dateLabel = UILabel()
    let noteLabel = UILabel()
    let perGLabel = UILabel()
    let perKGLbel = UILabel()
    
//    init(recordItem: RecordItem) {
//        self.recordItem = recordItem
//        super.init(style: .default, reuseIdentifier: nil)
//        setupCell()
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.backgroundColor = .white
//        guard let recordItem = recordItem else {return}
        
        nameLabael.text = recordItem?.name
        costLabel.text = "C : " + String(recordItem?.cost ?? 0)
        weightLabel.text = "W : " + String(recordItem?.weight ?? 0)
        perGLabel.text = "₽/g : " + String(format: "%.2f", recordItem?.costPerGr ?? 0)
//        String(format: "%.2f", (recordItem?.cost ?? 0) / (recordItem?.weight ?? 0))
        perKGLbel.text = "₽/kg : " + String(format: "%.2f", recordItem?.costPerKg ?? 0)
//        String(format: "%.2f", (recordItem?.cost ?? 0) / (recordItem?.weight ?? 00) * 1000)
        dateLabel.text = recordItem?.timeStamp?.moscowTimeDateFormatter()
        noteLabel.text = recordItem?.note
        
        contentView.addSubview(nameLabael)
        contentView.addSubview(costLabel)
        contentView.addSubview(weightLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(noteLabel)
        contentView.addSubview(perGLabel)
        contentView.addSubview(perKGLbel)
        
        nameLabael.translatesAutoresizingMaskIntoConstraints = false
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        perGLabel.translatesAutoresizingMaskIntoConstraints = false
        perKGLbel.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalGap: CGFloat = 0
        let horizontalGap: CGFloat = 18
        let rowHeight: CGFloat = 27
        
        nameLabael.font = .systemFont(ofSize: 18, weight: .semibold)
        
        nameLabael.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalGap).isActive = true
//        nameLabael.bottomAnchor.constraint(equalTo: , constant: verticalGap).isActive = true
        nameLabael.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalGap).isActive = true
        nameLabael.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalGap).isActive = true
        nameLabael.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        
        costLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        costLabel.topAnchor.constraint(equalTo: nameLabael.bottomAnchor, constant: -4).isActive = true
//        costLabel.bottomAnchor.constraint(equalTo: , constant: verticalGap).isActive = true
        costLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalGap).isActive = true
//        costLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalGap).isActive = true
        costLabel.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        
        weightLabel.font = .systemFont(ofSize: 15, weight: .regular)

        weightLabel.topAnchor.constraint(equalTo: nameLabael.bottomAnchor, constant: -4).isActive = true
//        weightLabel.bottomAnchor.constraint(equalTo: , constant: verticalGap).isActive = true
        weightLabel.leadingAnchor.constraint(equalTo: costLabel.trailingAnchor, constant: 10).isActive = true
//        weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalGap).isActive = true
        weightLabel.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        
        perGLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        perGLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalGap).isActive = true
        perGLabel.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: verticalGap).isActive = true
        
        perKGLbel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        perKGLbel.leadingAnchor.constraint(equalTo: perGLabel.trailingAnchor, constant: 10).isActive = true
        perKGLbel.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: verticalGap).isActive = true
        
        dateLabel.font = .systemFont(ofSize: 10, weight: .light, width: .standard)
        
//        dateLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: verticalGap).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: 0).isActive = true
//        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalGap).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        
        noteLabel.font = .systemFont(ofSize: 10, weight: .light, width: .standard)
        
        noteLabel.topAnchor.constraint(equalTo: perGLabel.bottomAnchor, constant: verticalGap).isActive = true
        noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalGap).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalGap).isActive = true
//        noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalGap).isActive = true
        noteLabel.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        noteLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 0.6).isActive = true
    }
    

}

import SwiftUI

//#Preview(body: {
//    let recordItem = RecordItem(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
//    recordItem.name = "Apples"
//    recordItem.cost = 157
//    recordItem.weight = 740
//    recordItem.timeStamp = Date()
//    recordItem.note = "Multiline\ntext"
//    let cell = ItemCell(style: .default, reuseIdentifier: ItemCell.reuseId)
//    cell.recordItem = recordItem
//    return cell
//})

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
    record.note = "From Wallmart From Wallmart From Wallmart From Wallmart"
    record.timeStamp = Date()
    itemsVC.localItemsArray = [record]
    
    let nvc = UINavigationController(rootViewController: itemsVC)
    nvc.navigationBar.prefersLargeTitles = true
    
    return nvc
})
