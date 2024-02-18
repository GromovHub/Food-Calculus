//
//  RecordItem+CoreDataProperties.swift
//  Food Calculus
//
//  Created by Vitaly Gromov on 15.02.2024.
//
//

import Foundation
import CoreData


extension RecordItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordItem> {
        return NSFetchRequest<RecordItem>(entityName: "RecordItem")
    }

    @NSManaged public var cost: Double
    @NSManaged public var costPerGr: Double
    @NSManaged public var costPerKg: Double
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var weight: Double
    @NSManaged public var parentCategory: CategoryItem?

}

extension RecordItem : Identifiable {

}
