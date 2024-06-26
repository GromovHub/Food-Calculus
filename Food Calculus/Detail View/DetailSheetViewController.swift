//
//  DetailSheetViewController.swift
//  Food Calculus
//
//  Created by Vitaly Gromov on 06.02.2024.
//

import Foundation
import UIKit

protocol DetailSheetViewControllerDelegate {
    func sheetDismiss()
}

class DetailSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    var deatilSheetParentCategory: CategoryItem?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: DetailSheetViewControllerDelegate?
    var recordingItem: RecordItem? {
        didSet {
            if recordingItem?.name == "noname" {
                print("Creating new record")
            } else {
                print("Editing an existing record -> \(String(describing: recordingItem?.name))")
            }
        }
    }
    
    lazy var imagePicker = UIImagePickerController()
    
    let closeButton: UIButton = UIButton(type: .system)
    let nameTextField = UITextField()
    let costTextField = UITextField()
    let weightTextField = UITextField()
    let timeStampLabel = UILabel()
    let noteTextView = UITextView()
    let justView = UIView()
    let categoryButton = UIButton(type: .system)
    
    let photoSegment = UIView()
    let photoPreview = UIImageView()
    let takePhotoButton = UIButton(type: .system)
    let deletePhotoButton = UIButton(type: .system)
    
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
    
    // MARK: - Initializers
    
    init(deatilSheetParentCategory: CategoryItem?) {
        self.deatilSheetParentCategory = deatilSheetParentCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
}



// MARK: - Setup Views

extension DetailSheetViewController {
    
    func setupViews() {
        view.backgroundColor = .white
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        nameTextField.becomeFirstResponder()
        nameTextField.returnKeyType = .next
        nameTextField.delegate = self
        
        if  recordingItem == nil {
//            print("create new from details")
//            recordingItem = RecordItem(context: context)
//            recordingItem?.parentCategory = self.deatilSheetParentCategory
//            recordingItem?.cost = 0
//            recordingItem?.weight = 0
//            recordingItem?.timeStamp = Date()
        } else {
            print("will edit exist")
            guard let recordingItem = recordingItem else {return} // just for comfort
            nameTextField.text = recordingItem.name
            costTextField.text = String(recordingItem.cost)
            weightTextField.text = String(recordingItem.weight)
            noteTextView.text = recordingItem.note
            
            if let photoData = recordingItem.photo {
                photoPreview.image = convertDataToPhoto(data: photoData)
            }
        }
        
        view.addSubview(justView)
        justView.addSubview(nameTextField)
        justView.addSubview(costTextField)
        justView.addSubview(weightTextField)
        justView.addSubview(timeStampLabel)
        justView.addSubview(categoryButton)
        justView.addSubview(noteTextView)
        
        justView.addSubview(photoSegment)
        photoSegment.addSubview(photoPreview)
        photoSegment.addSubview(takePhotoButton)
        photoSegment.addSubview(deletePhotoButton)
        
        view.addSubview(closeButton)
        
        nameTextField.placeholder = "Record name"
        costTextField.placeholder = "Cost"
        weightTextField.placeholder = "Weight"
        
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
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        justView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        photoSegment.translatesAutoresizingMaskIntoConstraints = false
        photoPreview.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        deletePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        if recordingItem == nil {
            timeStampLabel.text = Date().moscowTimeDateFormatter()
        } else {
            timeStampLabel.text = recordingItem?.timeStamp?.moscowTimeDateFormatter()
        }
        timeStampLabel.textAlignment = .right
        
        timeStampLabel.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: verticalGap).isActive = true
        timeStampLabel.leadingAnchor.constraint(equalTo: justView.leadingAnchor, constant: horizontalGap).isActive = true
        timeStampLabel.trailingAnchor.constraint(equalTo: justView.trailingAnchor, constant: -horizontalGap).isActive = true
        timeStampLabel.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        if recordingItem == nil {
            categoryButton.setTitle(self.deatilSheetParentCategory?.name, for: .normal)
        } else {
            categoryButton.setTitle(recordingItem?.parentCategory?.name, for: .normal)
        }
        categoryButton.menu = UIMenu(title: "Menu", image: nil, identifier: nil, options: .singleSelection, children: [
            UIAction(title: "action", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .keepsMenuPresented, state: .on, handler: { _ in
                print("works")
            })
        ])
        
        categoryButton.topAnchor.constraint(equalTo: timeStampLabel.bottomAnchor, constant: verticalGap).isActive = true
        categoryButton.trailingAnchor.constraint(equalTo: justView.trailingAnchor, constant: -horizontalGap).isActive = true
        
        noteTextView.layer.cornerRadius = 10
        
        noteTextView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: verticalGap).isActive = true
        noteTextView.leadingAnchor.constraint(equalTo: justView.leadingAnchor, constant: horizontalGap).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: justView.bottomAnchor, constant: -verticalGap).isActive = true
        noteTextView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        
        photoSegment.backgroundColor = .systemGray5
        photoSegment.layer.cornerRadius = 10
        
        photoSegment.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: verticalGap).isActive = true
        photoSegment.bottomAnchor.constraint(equalTo: justView.bottomAnchor, constant: -verticalGap).isActive = true
        photoSegment.leadingAnchor.constraint(equalTo: noteTextView.trailingAnchor, constant: 10).isActive = true
        photoSegment.trailingAnchor.constraint(equalTo: justView.trailingAnchor, constant: -10).isActive = true
        
//        photoPreview.image = UIImage(systemName: "questionmark")
        
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        photoPreview.isUserInteractionEnabled = true
        photoPreview.addGestureRecognizer(photoTap)
        photoPreview.contentMode = .scaleAspectFill
        photoPreview.layer.cornerRadius = 10
        photoPreview.layer.borderColor = UIColor.white.cgColor
        photoPreview.layer.borderWidth = 1
        photoPreview.clipsToBounds = true
        
        
        photoPreview.topAnchor.constraint(equalTo: photoSegment.topAnchor, constant: 10).isActive = true
        photoPreview.leadingAnchor.constraint(equalTo: photoSegment.leadingAnchor, constant: 5).isActive = true
        photoPreview.trailingAnchor.constraint(equalTo: photoSegment.trailingAnchor, constant: -5).isActive = true
        photoPreview.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        takePhotoButton.setTitle("Take Photo", for: .normal)
        takePhotoButton.addTarget(self, action: #selector(takePhotoButtonTapped), for: .touchUpInside)
        
//        takePhotoButton.topAnchor.constraint(equalTo: photoPreview.bottomAnchor, constant: 0).isActive = true
        takePhotoButton.leadingAnchor.constraint(equalTo: photoSegment.leadingAnchor, constant: 10).isActive = true
        takePhotoButton.bottomAnchor.constraint(equalTo: deletePhotoButton.topAnchor, constant: -10).isActive = true
        
        deletePhotoButton.setTitle("Delete Photo", for: .normal)
        deletePhotoButton.addTarget(self, action: #selector(deletePhotoButtonTapped), for: .touchUpInside)
        
        deletePhotoButton.bottomAnchor.constraint(equalTo: photoSegment.bottomAnchor, constant: -10).isActive = true
        deletePhotoButton.leadingAnchor.constraint(equalTo: photoSegment.leadingAnchor, constant: 10).isActive = true
        
        
        closeButton.addTarget(self, action: #selector(addAndCloseButtonTapepd), for: .touchUpInside)
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
}

// MARK: - View Actions

extension DetailSheetViewController {
    
    @objc func takePhotoButtonTapped() {
        present(imagePicker, animated: true)
    }
    
    @objc func deletePhotoButtonTapped() {
        photoPreview.image = nil
        recordingItem?.photo = nil
    }
    
    @objc func imageTapped() {
        print("Image Tapped")
        guard let photo = photoPreview.image else {return}
        present(ZoomSheetViewController(photo: photo), animated: true)
    }
    
    @objc func addAndCloseButtonTapepd() {
//        guard let recordingItem = recordingItem else {return} // only for comfort
        if let recordingItem = recordingItem {
            recordingItem.name = nameTextField.text
            recordingItem.cost = Double(costTextField.text ?? "0") ?? 0
            recordingItem.weight = Double(weightTextField.text ?? "0") ?? 0
            recordingItem.note = noteTextView.text
            recordingItem.costPerGr = recordingItem.cost / recordingItem.weight
            recordingItem.costPerKg = recordingItem.costPerGr * 1000
            
            
            if let photo = photoPreview.image {
                recordingItem.photo = convertPhotoToData(photo: photo)
            } else {
                recordingItem.photo = nil
            }
        } else {
            self.recordingItem = RecordItem(context: context)
            guard let newRecord = recordingItem else {return}
            newRecord.parentCategory = self.deatilSheetParentCategory
            newRecord.timeStamp = Date()
            newRecord.name = nameTextField.text
            newRecord.cost = Double(costTextField.text ?? "0") ?? 0
            newRecord.weight = Double(weightTextField.text ?? "0") ?? 0
            newRecord.note = noteTextView.text
            newRecord.costPerGr = newRecord.cost / newRecord.weight
            newRecord.costPerKg = newRecord.costPerGr * 1000
            
            
            if let photo = photoPreview.image {
                newRecord.photo = convertPhotoToData(photo: photo)
            } else {
                newRecord.photo = nil
            }
        }
        saveContext()
        delegate?.sheetDismiss()
    }
    
}

// MARK: - TextField Delegate

extension DetailSheetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        costTextField.becomeFirstResponder()
        return true
    }
}

// MARK: - ImagePicker

extension DetailSheetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoPreview.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func convertPhotoToData(photo: UIImage) -> Data?{
        if let data = photo.jpegData(compressionQuality: 0.8) {
            return data
        } else {
            print("can't convert photo to data")
            return nil
        }
    }
    
    func convertDataToPhoto(data: Data) -> UIImage? {
        if let image = UIImage(data: data) {
            return image
        } else {
            print("can't convert data to photo")
            return nil
        }
    }
}

// MARK: - Date Formatter

extension Date {
    
    func moscowTimeDateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        let moscowTimeString = dateFormatter.string(from: self)
//        print("Moscow Time: \(moscowTimeString)")
        return moscowTimeString
    }
    
    func moscowTimeDateFormatter(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        let moscowTimeString = dateFormatter.string(from: date)
        return moscowTimeString
    }
}

// MARK: - CoreData

extension DetailSheetViewController {
    
    func saveContext() {
        do {
            try context.save()
            print("Changes from detail sheet are saved +")
        } catch {
            print("save-")
        }
    }
    
}

// MARK: - SwiftUI Preview

import SwiftUI
#Preview(body: {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let cat = CategoryItem(context: context)
    cat.name = "Apples"
    return DetailSheetViewController(deatilSheetParentCategory: cat)
})
