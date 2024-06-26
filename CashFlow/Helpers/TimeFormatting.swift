//
//  TimeFormatting.swift
//  CashFlow
//
//  Created by Паша on 28.02.24.
//

import Foundation

func calcTimeSince(date: Date) -> String {
    let calendar = Calendar.current
    
    let now = Date()
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
    
    if let years = components.year, years > 0, years < 5 {
        return "\(years) г назад"
    } else if let years = components.year, years >= 5 {
        return "\(years) лет назад"
    } else if let months = components.month, months > 0 {
        return "\(months) мес назад"
    } else if let days = components.day, days > 0 {
        return "\(days) дн назад"
    } else if let hours = components.hour, hours > 0 {
        return "\(hours) ч назад"
    } else if let minutes = components.minute, minutes > 0 {
        return "\(minutes) мин назад"
    } else {
        return "Только что"
    }
}


