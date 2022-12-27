//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by 김인호 on 2022/12/27.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var createdDate: String?

}