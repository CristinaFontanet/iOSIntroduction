//
//  Link+CoreDataProperties.swift
//  Projecte
//
//  Created by 1181432 on 5/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Link {

    @NSManaged var language: String?
    @NSManaged var link: String?
    @NSManaged var manual: Manual?

}
