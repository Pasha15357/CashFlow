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

    let components = calendar.dateComponents(
        [.year, .day, .hour, .minute],
        from: date,
        to: now
    )

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")

    if let years = components.year, years > 0 {
        formatter.dateFormat = "d MMMM yyyy 'г.'"
        return formatter.string(from: date)

    } else if let days = components.day, days > 1 {
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)

    } else if let days = components.day, days == 1 {
        return "Вчера"

    } else if let hours = components.hour, hours > 0 {
        return "\(hours) ч назад"

    } else if let minutes = components.minute, minutes > 0 {
        return "\(minutes) мин назад"

    } else {
        return "Только что"
    }
}


