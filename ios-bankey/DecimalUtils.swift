//
//  DecimalUtils.swift
//  ios-bankey
//
//  Created by Jorge Andres Restrepo Gutierrez on 10/10/22.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
