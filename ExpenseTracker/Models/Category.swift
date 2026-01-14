import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID
    var name: String
    var icon: String
    var colorHex: String
    
    init(name: String, icon: String, colorHex: String) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
    }
    
    // Predefined categories
    static let predefinedCategories: [Category] = [
        Category(name: "Food & Dining", icon: "fork.knife", colorHex: "#FF6B6B"),
        Category(name: "Transport", icon: "car.fill", colorHex: "#4ECDC4"),
        Category(name: "Entertainment", icon: "tv.fill", colorHex: "#FFE66D"),
        Category(name: "Shopping", icon: "bag.fill", colorHex: "#A8E6CF"),
        Category(name: "Bills & Utilities", icon: "doc.text.fill", colorHex: "#FF8B94"),
        Category(name: "Health & Fitness", icon: "heart.fill", colorHex: "#C7CEEA"),
        Category(name: "Education", icon: "book.fill", colorHex: "#B4A7D6"),
        Category(name: "Others", icon: "ellipsis.circle.fill", colorHex: "#95A5A6")
    ]
}
