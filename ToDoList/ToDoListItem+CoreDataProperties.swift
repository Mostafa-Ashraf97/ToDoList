//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoList
//
//  Created by A on 30/05/2023.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var name: String?

}

extension ToDoListItem : Identifiable {

}
