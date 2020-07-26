//
//  SandwichModel+CoreDataProperties.swift
//  SandwichSaturation
//
//  Created by Maitri Mehta on 7/20/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//
//

import Foundation
import CoreData


extension SandwichModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SandwichModel> {
        return NSFetchRequest<SandwichModel>(entityName: "SandwichModel")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var sauceAmount: SauceAmountModel?

}
