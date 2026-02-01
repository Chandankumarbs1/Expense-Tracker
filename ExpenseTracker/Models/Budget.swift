import Foundation
import SwiftData

@Model
final class Budget {
    var id: UUID
    var amount: Double
    var month: Int
    var year: Int
    var createdAt: Date
    
    init(amount: Double, month: Int, year: Int) {
        self.id = UUID()
        self.amount = amount
        self.month = month
        self.year = year
        self.createdAt = Date()
    }
    
    // Computed property for formatted budget amount in INR
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "₹0"
    }
    
    // Helper to get current month's budget
    static func currentMonthBudget(from budgets: [Budget]) -> Budget? {
        let now = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        return budget(for: currentMonth, year: currentYear, from: budgets)
    }
    
    // Helper to get budget for a specific month and year
    static func budget(for month: Int, year: Int, from budgets: [Budget]) -> Budget? {
        return budgets.first { $0.month == month && $0.year == year }
    }
}
