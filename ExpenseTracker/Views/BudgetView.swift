import SwiftUI
import SwiftData

struct BudgetView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var budgets: [Budget]
    @Query private var expenses: [Expense]
    
    @State private var showingSetBudget = false
    @State private var budgetAmount = ""
    
    var currentBudget: Budget? {
        Budget.currentMonthBudget(from: budgets)
    }
    
    var currentMonthExpenses: [Expense] {
        expenses.filter { $0.date.isInCurrentMonth }
    }
    
    var totalSpent: Double {
        currentMonthExpenses.reduce(0) { $0 + $1.amount }
    }
    
    var remaining: Double {
        (currentBudget?.amount ?? 0) - totalSpent
    }
    
    var progress: Double {
        guard let budget = currentBudget, budget.amount > 0 else { return 0 }
        return min(totalSpent / budget.amount, 1.0)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        // Current Month Header
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                                Text("Monthly Budget")
                                    .font(Theme.Typography.headline)
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                Text(Date().monthYear)
                                    .font(Theme.Typography.largeTitle)
                                    .foregroundColor(Theme.Colors.primaryText)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.top, Theme.Spacing.md)
                        
                        if let budget = currentBudget {
                            // Budget Overview Card
                            BudgetOverviewCard(
                                budget: budget.amount,
                                spent: totalSpent,
                                remaining: remaining,
                                progress: progress
                            )
                            .padding(.horizontal, Theme.Spacing.lg)
                            
                            // Budget Stats
                            BudgetStatsGrid(
                                budget: budget.amount,
                                spent: totalSpent,
                                remaining: remaining
                            )
                            .padding(.horizontal, Theme.Spacing.lg)
                            
                            // Update Budget Button
                            Button {
                                budgetAmount = String(format: "%.0f", budget.amount)
                                showingSetBudget = true
                            } label: {
                                Text("Edit Budget")
                                    .font(Theme.Typography.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, Theme.Spacing.md)
                                    .background(Theme.Colors.primary)
                                    .cornerRadius(Theme.CornerRadius.lg)
                                    .shadow(color: Theme.Colors.primary.opacity(0.3), radius: 10, y: 5)
                            }
                            .padding(.horizontal, Theme.Spacing.lg)
                            .padding(.top, Theme.Spacing.md)
                            
                        } else {
                            // No Budget Set
                            VStack(spacing: Theme.Spacing.lg) {
                                Image(systemName: "indianrupeesign.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(Theme.Colors.tertiaryText)
                                
                                Text("Budgeting starts here")
                                    .font(Theme.Typography.title2)
                                    .foregroundColor(Theme.Colors.primaryText)
                                
                                Text("Set a monthly budget to track your spending and achieve your savings goals.")
                                    .font(Theme.Typography.body)
                                    .foregroundColor(Theme.Colors.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, Theme.Spacing.xl)
                                
                                Button {
                                    showingSetBudget = true
                                } label: {
                                    Label("Set Monthly Budget", systemImage: "plus.circle.fill")
                                        .font(Theme.Typography.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, Theme.Spacing.lg)
                                        .padding(.vertical, Theme.Spacing.md)
                                        .background(Theme.Colors.primary)
                                        .cornerRadius(Theme.CornerRadius.lg)
                                        .shadow(color: Theme.Colors.primary.opacity(0.3), radius: 10, y: 5)
                                }
                            }
                            .padding(.vertical, Theme.Spacing.xxl)
                        }
                    }
                    .padding(.bottom, Theme.Spacing.lg)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSetBudget) {
                SetBudgetSheet(
                    currentAmount: budgetAmount,
                    onSave: { amount in
                        saveBudget(amount: amount)
                    }
                )
            }
        }
    }
    
    private func saveBudget(amount: Double) {
        let calendar = Calendar.current
        let now = Date()
        let month = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: now)
        
        if let existingBudget = currentBudget {
            existingBudget.amount = amount
        } else {
            let newBudget = Budget(amount: amount, month: month, year: year)
            modelContext.insert(newBudget)
        }
        
        try? modelContext.save()
    }
}

// MARK: - Budget Overview Card
struct BudgetOverviewCard: View {
    let budget: Double
    let spent: Double
    let remaining: Double
    let progress: Double
    
    var statusColor: Color {
        if progress >= 1.0 { return Theme.Colors.danger }
        if progress >= 0.8 { return Theme.Colors.warning }
        return Theme.Colors.success
    }
    
    var statusText: String {
        if progress >= 1.0 { return "Over Budget!" }
        if progress >= 0.8 { return "Almost There" }
        return "On Track"
    }
    
    var formattedRemaining: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: abs(remaining))) ?? "₹0"
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Status Badge
            HStack {
                Spacer()
                Text(statusText)
                    .font(Theme.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, Theme.Spacing.xs)
                    .background(statusColor)
                    .cornerRadius(Theme.CornerRadius.full)
            }
            
            // Remaining Amount
            VStack(spacing: Theme.Spacing.xs) {
                Text(remaining >= 0 ? "Remaining" : "Over Budget")
                    .font(Theme.Typography.subheadline)
                    .foregroundColor(Theme.Colors.secondaryText)
                
                Text(formattedRemaining)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(statusColor)
            }
            
            // Progress Circle
            ZStack {
                Circle()
                    .stroke(Theme.Colors.tertiaryBackground, lineWidth: 12)
                    .frame(width: 160, height: 160)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(statusColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)
                
                VStack(spacing: 4) {
                    Text("\(Int(progress * 100))%")
                        .font(Theme.Typography.title1)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Text("Used")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.secondaryText)
                }
            }
            .padding(.vertical, Theme.Spacing.md)
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Theme.CornerRadius.lg)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Budget Stats Grid
struct BudgetStatsGrid: View {
    let budget: Double
    let spent: Double
    let remaining: Double
    
    var formattedBudget: String {
        formatCurrency(budget)
    }
    
    var formattedSpent: String {
        formatCurrency(spent)
    }
    
    var formattedRemaining: String {
        formatCurrency(remaining)
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "₹0"
    }
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            StatCard(title: "Budget", value: formattedBudget, color: Theme.Colors.primary)
            StatCard(title: "Spent", value: formattedSpent, color: Theme.Colors.danger)
            StatCard(title: "Left", value: formattedRemaining, color: Theme.Colors.success)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.secondaryText)
            
            Text(value)
                .font(Theme.Typography.headline)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.md)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Theme.CornerRadius.md)
        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 1)
    }
}

// MARK: - Set Budget Sheet
struct SetBudgetSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var amount: String
    let onSave: (Double) -> Void
    
    @State private var showError = false
    
    init(currentAmount: String = "", onSave: @escaping (Double) -> Void) {
        _amount = State(initialValue: currentAmount)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("₹")
                            .font(Theme.Typography.title2)
                            .foregroundColor(Theme.Colors.primary)
                        TextField("Enter amount", text: $amount)
                            .keyboardType(.numberPad)
                            .font(Theme.Typography.title2)
                    }
                } header: {
                    Text("Monthly Budget")
                } footer: {
                    Text("Set your monthly spending limit to track your expenses effectively")
                }
            }
            .navigationTitle("Set Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBudget()
                    }
                    .fontWeight(.semibold)
                }
            }
            .alert("Invalid Amount", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid amount greater than 0")
            }
        }
    }
    
    private func saveBudget() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            showError = true
            return
        }
        
        onSave(amountValue)
        dismiss()
    }
}

// Preview removed due to @Query private initializer
