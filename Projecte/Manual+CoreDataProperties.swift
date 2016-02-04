//
//  Manual+CoreDataProperties.swift
//  Projecte
//
//  Created by 1181432 on 3/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Manual {

    @NSManaged var name: String?
    @NSManaged var imagePath: String?
    @NSManaged var link: NSSet?

}
