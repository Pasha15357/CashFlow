//
//  TimeFormatting.swift
//  CashFlow
//
//  Created by Паша on 28.02.24.
//

import Foundation

func calcTimeSince(date: Date) -> String {
    let minutes = Int(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
    
    if minutes < 60 {
        return "\(minutes) мин назад"
    } else if minutes >= 60 && hours < 48 {
        return "\(hours) часов назад"
    } else {
        return "\(days) дней назад"
    }
}
