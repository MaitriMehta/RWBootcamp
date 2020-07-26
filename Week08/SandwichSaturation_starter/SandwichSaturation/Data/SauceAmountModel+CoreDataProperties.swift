//
//  SauceAmountModel+CoreDataProperties.swift
//  SandwichSaturation
//
//  Created by Maitri Mehta on 7/20/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//
//

import Foundation
import CoreData


extension SauceAmountModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SauceAmountModel> {
        return NSFetchRequest<SauceAmountModel>(entityName: "SauceAmountModel")
    }

    @NSManaged public var sauceAmountString: String?
    @NSManaged public var sandwiches: NSSet?

}

// MARK: Generated accessors for sandwiches
extension SauceAmountModel {

    @objc(addSandwichesObject:)
    @NSManaged public func addToSandwiches(_ value: SandwichModel)
    
    @objc(removeSandwichesObject:)
    @NSManaged public func removeFromSandwiches(_ value: SandwichModel)

}
