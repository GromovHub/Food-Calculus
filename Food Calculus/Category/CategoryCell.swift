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
        var defaultConfig = self.defaultContentConfiguration()
        defaultConfig.text = text
        self.contentConfiguration = defaultConfig
    }
}

