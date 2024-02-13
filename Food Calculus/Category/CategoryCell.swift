//
//  CategoryCell.swift
//  Food Calculus
//
//  Created by Vitaly Gromov on 04.02.2024.
//

import Foundation
import UIKit

class CategoryCell: UITableViewCell {

    static let cellId = "CategoryCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellConfig()
    }
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellConfig(text: String = "no text") {
//        contentView.backgroundColor = UIColor(red: 0.66, green: 0.85, blue: 0.86, alpha: 1.00)
//        contentView.backgroundColor = .systemGray6
        var defaultConfig = self.defaultContentConfiguration()
        defaultConfig.text = text
//        defaultConfig.textProperties.color = UIColor(red: 0.11, green: 0.21, blue: 0.34, alpha: 1.00)
        self.contentConfiguration = defaultConfig
        
    }
    
}

