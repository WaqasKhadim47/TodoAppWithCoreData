//
//  TodoListItem+CoreDataProperties.swift
//  TodoAppWithCoreData
//
//  Created by Waqas Khadim on 19/08/2022.
//
//

import Foundation
import CoreData


extension TodoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListItem> {
        return NSFetchRequest<TodoListItem>(entityName: "TodoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension TodoListItem : Identifiable {

}
