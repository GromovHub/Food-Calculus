//
//  DetailSheetViewController.swift
//  Food Calculus
//
//  Created by Vitaly Gromov on 06.02.2024.
//

import Foundation
import UIKit

protocol DetailSheetViewControllerDelegate {
    func sheetDismiss(category: CategoryItem?)
}

class DetailSheetViewController: UIViewController {
    
    var parentCategory: CategoryItem?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: DetailSheetViewControllerDelegate?
    var recordingItem: RecordItem?
    
    let closeButton: UIButton = UIButton(type: .system)
    let nameTextField = UITextField()
    let costTextField = UITextField()
    let weightTextField = UITextField()
    let timeStampLabel = UILabel()
    let noteTextView = UITextView()
    let justView = UIView()
    
    let moneySign: UIImageView = {
       let x = UIImageView()
        x.image = UIImage(systemName: "rublesign.circle")
        return x
    }()
    
    let weightSign: UIImageView = {
       let x = UIImageView()
        x.image = UIImage(systemName: "scalemass")
        return x
    }()
    
    let titleSign: UIImageView = {
       let x = UIImageView()
        x.image = UIImage(systemName: "t.circle")
        return x
    }()
    
    
    init(parentCategory: CategoryItem?) {
        self.parentCategory = parentCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if  recordingItem == nil {
            recordingItem = RecordItem(context: context)
            recordingItem?.timeStamp = Date()
        } else {
            guard let recordingItem = recordingItem else {return}
            nameTextField.text = recordingItem.name
            costTextField.text = String(recordingItem.cost)
            weightTextField.text = String(recordingItem.weight)
            noteTextView.text = recordingItem.note
            timeStampLabel.text = recordingItem.timeStamp?.moscowTimeDateFormatter()
        }
        guard let recordingItem = recordingItem else {return}
//        guard let recordingItem = recordingItem else {
//            recordingItem = RecordItem(context: context)
//            recordingItem?.timeStamp = Date()
//            return
//        }
        
        
        view.addSubview(justView)
        justView.addSubview(nameTextField)
        justView.addSubview(costTextField)
        justView.addSubview(weightTextField)
        justView.addSubview(timeStampLabel)
        justView.addSubview(noteTextView)
        view.addSubview(closeButton)
        
        nameTextField.placeholder = "Record name"
        costTextField.placeholder = "Cost"
        weightTextField.placeholder = "Weight"
        
//        guard let recordingItem = recordingItem else {return}
//        nameTextField.text = recordingItem.name
//        costTextField.text = String(recordingItem.cost)
//        weightTextField.text = String(recordingItem.weight)
//        noteTextView.text = recordingItem.note
//        timeStampLabel.text = recordingItem.timeStamp?.moscowTimeDateFormatter()
        
        costTextField.rightViewMode = .always
        costTextField.rightView = {
           let x = UIView()
            x.backgroundColor = .cyan
            return x
        }()
        
        let horizontalGap: CGFloat = 16
        let verticalGap: CGFloat = 24
        let cellHeight: CGFloat = 40
        
        costTextField.keyboardType = .decimalPad
        weightTextField.keyboardType = .decimalPad
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        costTextField.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        justView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        justView.layer.cornerRadius = 10
        justView.backgroundColor = .systemGray6
        
        justView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalGap).isActive = true
        justView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalGap).isActive = true
        justView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalGap).isActive = true
        justView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -verticalGap).isActive = true
        
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.cornerRadius = 10
        nameTextField.rightViewMode = .always
        nameTextField.rightView = titleSign
        
        nameTextField.topAnchor.constraint(equalTo: justView.topAnchor, constant: verticalGap).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: justView.leadingAnchor, constant: horizontalGap).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: justView.trailingAnchor, constant: -horizontalGap).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        
        costTextField.layer.cornerRadius = 10
        costTextField.rightViewMode = .always
        costTextField.rightView = moneySign
        
        costTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: verticalGap).isActive = true
        costTextField.leadingAnchor.constraint(equalTo: justView.leadingAnchor, constant: horizontalGap).isActive = true
        costTextField.trailingAnchor.constraint(equalTo: justView.trailingAnchor, constant: -horizontalGap).isActive = true
        costTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        weightTextField.layer.cornerRadius = 10
        weightTextField.rightViewMode = .always
        weightTextField.rightView = weightSign
        
        weightTextField.topAnchor.constraint(equalTo: costTextField.bottomAnchor, constant: verticalGap).isActive = true
        weightTextField.leadingAnchor.constraint(equalTo: justView.leadingAnchor, constant: horizontalGap).isActive = true
        weightTextField.trailingAnchor.constraint(equalTo: justView.trailingAnchor, constant: -horizontalGap).isActive = true
        weightTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        timeStampLabel.text = "n/d"
        timeStampLabel.text = moscowTimeDateFormatter((recordingItem.timeStamp)!)
        timeStampLabel.textAlignment = .right
        
        timeStampLabel.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: verticalGap).isActive = true
        timeStampLabel.leadingAnchor.constraint(equalTo: justView.leadingAnchor, constant: horizontalGap).isActive = true
        timeStampLabel.trailingAnchor.constraint(equalTo: justView.trailingAnchor, constant: -horizontalGap).isActive = true
        timeStampLabel.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        noteTextView.layer.cornerRadius = 10
        
        noteTextView.topAnchor.constraint(equalTo: timeStampLabel.bottomAnchor, constant: verticalGap).isActive = true
        noteTextView.leadingAnchor.constraint(equalTo: justView.leadingAnchor, constant: horizontalGap).isActive = true
        noteTextView.trailingAnchor.constraint(equalTo: justView.trailingAnchor, constant: -horizontalGap).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: justView.bottomAnchor, constant: -verticalGap).isActive = true
        
        closeButton.addTarget(self, action: #selector(buttonTapepd), for: .touchUpInside)
        closeButton.layer.cornerRadius = 10
        closeButton.backgroundColor = .systemGray6
        closeButton.titleLabel?.font = .systemFont(ofSize: 18)
        closeButton.tintColor = .black
        closeButton.setTitle("Add and close", for: .normal)
                
        closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalGap).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalGap).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func moscowTimeDateFormatter(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        let moscowTimeString = dateFormatter.string(from: date)
        return moscowTimeString
    }
    
    @objc func buttonTapepd() {
        guard let recordingItem = recordingItem else {return}
        if parentCategory != nil {
            recordingItem.parentCategory = parentCategory
        }
        recordingItem.name = nameTextField.text
        recordingItem.cost = Double(costTextField.text!)!
        recordingItem.weight = Double(weightTextField.text!)!
        recordingItem.note = noteTextView.text
        recordingItem.costPerGr = recordingItem.cost / recordingItem.weight
        recordingItem.costPerKg = recordingItem.costPerGr * 1000
        saveContext()
        delegate?.sheetDismiss(category: parentCategory)
    }
    
    func saveContext() {
        do {
            try context.save()
            print("Changes from detail sheet are saved +")
        } catch {
            print("save-")
        }
    }
    
}

import SwiftUI
#Preview(body: {
    DetailSheetViewController(parentCategory: CategoryItem())
})

extension Date {
    func moscowTimeDateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        let moscowTimeString = dateFormatter.string(from: self)
//        print("Moscow Time: \(moscowTimeString)")
        return moscowTimeString
    }
}
