//
//  CategoryItem+CoreDataProperties.swift
//  Food Calculus
//
//  Created by Vitaly Gromov on 15.02.2024.
//
//

import Foundation
import CoreData


extension CategoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryItem> {
        return NSFetchRequest<CategoryItem>(entityName: "CategoryItem")
    }

    @NSManaged public var name: String
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension CategoryItem {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: RecordItem)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: RecordItem)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}

extension CategoryItem : Identifiable {

}
