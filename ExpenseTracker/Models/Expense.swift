import Foundation
import SwiftData

@Model
final class Expense {
    var id: UUID
    var amount: Double
    var category: Category?
    var date: Date
    var notes: String
    var createdAt: Date
    
    init(amount: Double, category: Category?, date: Date, notes: String = "") {
        self.id = UUID()
        self.amount = amount
        self.category = category
        self.date = date
        self.notes = notes
        self.createdAt = Date()
    }
    
    // Computed property for formatted amount in INR
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "₹0.00"
    }
}
