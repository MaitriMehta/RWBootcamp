//
//  Date.swift
//  Birdie-Final
//
//  Created by Maitri Mehta on 6/28/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation
extension Date {
    func toString(withFormat format: String = "d MMM, HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
}
