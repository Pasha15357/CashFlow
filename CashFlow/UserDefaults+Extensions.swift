//
//  UserDefaults+Extensions.swift
//  CashFlow
//
//  Created by Паша on 8.04.24.
//

import Foundation

extension UserDefaults {
    var selectedCurrencyIndex: Int? {
        get { return integer(forKey: "selectedCurrencyIndex") }
        set { set(newValue, forKey: "selectedCurrencyIndex") }
    }
}
