import SwiftUI
import Charts

struct CategoryChartView: View {
    let expenses: [Expense]
    
    var categoryTotals: [(category: Category, total: Double)] {
        let grouped = Dictionary(grouping: expenses.compactMap { $0.category != nil ? $0 : nil }) { $0.category! }
        return grouped.map { (category: $0.key, total: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.total > $1.total }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            if categoryTotals.isEmpty {
                Text("No data available")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, Theme.Spacing.xl)
            } else {
                // Pie Chart
                Chart(categoryTotals, id: \.category.id) { item in
                    SectorMark(
                        angle: .value("Amount", item.total),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(Color(hex: item.category.colorHex))
                    .cornerRadius(4)
                }
                .frame(height: 220)
                .padding(.vertical, Theme.Spacing.sm)
                
                // Legend
                VStack(spacing: Theme.Spacing.sm) {
                    ForEach(categoryTotals, id: \.category.id) { item in
                        CategoryLegendRow(
                            category: item.category,
                            amount: item.total,
                            percentage: (item.total / expenses.reduce(0) { $0 + $1.amount }) * 100
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Category Legend Row
struct CategoryLegendRow: View {
    let category: Category
    let amount: Double
    let percentage: Double
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "₹0"
    }
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            // Color indicator
            Circle()
                .fill(Color(hex: category.colorHex))
                .frame(width: 12, height: 12)
            
            // Category icon and name
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: category.icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: category.colorHex))
                
                Text(category.name)
                    .font(Theme.Typography.subheadline)
                    .foregroundColor(Theme.Colors.primaryText)
            }
            
            Spacer()
            
            // Amount and percentage
            VStack(alignment: .trailing, spacing: 2) {
                Text(formattedAmount)
                    .font(Theme.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.primaryText)
                
                Text(String(format: "%.1f%%", percentage))
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.secondaryText)
            }
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

#Preview {
    CategoryChartView(expenses: [])
        .padding()
}
