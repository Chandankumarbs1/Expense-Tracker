import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [Expense]
    @Query private var budgets: [Budget]
    
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingAddExpense = false
    @State private var showingSettings = false
    
    var currentMonthExpenses: [Expense] {
        expenses.filter { $0.date.isInCurrentMonth }
    }
    
    var totalSpentThisMonth: Double {
        currentMonthExpenses.reduce(0) { $0 + $1.amount }
    }
    
    var currentBudget: Budget? {
        Budget.currentMonthBudget(from: budgets)
    }
    
    var budgetProgress: Double {
        guard let budget = currentBudget, budget.amount > 0 else { return 0 }
        return min(totalSpentThisMonth / budget.amount, 1.0)
    }
    
    var recentExpenses: [Expense] {
        Array(expenses.sorted { $0.date > $1.date }.prefix(5))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        // Header
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                Text("Overview")
                                    .font(Theme.Typography.headline)
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                Text(Date().monthYear)
                                    .font(Theme.Typography.largeTitle)
                                    .foregroundColor(Theme.Colors.primaryText)
                            }
                            
                            Spacer()
                            
                            Button {
                                showingSettings = true
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .font(.title3)
                                    .foregroundColor(Theme.Colors.secondaryText)
                                    .padding(8)
                                    .background(Theme.Colors.secondaryBackground)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.top, Theme.Spacing.md)
                        
                        // Spending Summary Card
                        SpendingSummaryCard(
                            totalSpent: totalSpentThisMonth,
                            budget: currentBudget?.amount,
                            progress: budgetProgress
                        )
                        .padding(.horizontal, Theme.Spacing.lg)
                        
                        // Category Breakdown
                        if !currentMonthExpenses.isEmpty {
                            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                                Text("Spending by Category")
                                    .font(Theme.Typography.title3)
                                    .foregroundColor(Theme.Colors.primaryText)
                                    .padding(.horizontal, Theme.Spacing.lg)
                                
                                CategoryChartView(expenses: currentMonthExpenses)
                                    .padding(.horizontal, Theme.Spacing.lg)
                            }
                        }
                        
                        // Recent Transactions
                        if !recentExpenses.isEmpty {
                            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                                HStack {
                                    Text("Recent Transactions")
                                        .font(Theme.Typography.title3)
                                        .foregroundColor(Theme.Colors.primaryText)
                                    Spacer()
                                    NavigationLink {
                                        ExpenseListView()
                                    } label: {
                                        Text("See All")
                                            .font(Theme.Typography.footnote)
                                            .foregroundColor(Theme.Colors.primary)
                                    }
                                }
                                .padding(.horizontal, Theme.Spacing.lg)
                                
                                VStack(spacing: Theme.Spacing.sm) {
                                    ForEach(recentExpenses) { expense in
                                        ExpenseRow(expense: expense)
                                            .padding(.horizontal, Theme.Spacing.lg)
                                            .padding(.vertical, 4)
                                            .background(Theme.Colors.cardBackground.opacity(0.5))
                                            .cornerRadius(Theme.CornerRadius.md)
                                            .padding(.horizontal, Theme.Spacing.lg)
                                    }
                                }
                            }
                        }
                        
                        // Empty State if no expenses
                        if expenses.isEmpty {
                            EmptyStateDashboardView(onAdd: { showingAddExpense = true })
                        }
                    }
                    .padding(.bottom, Theme.Spacing.lg)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(themeManager)
            }
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $themeManager.theme) {
                        ForEach(ThemeManager.AppTheme.allCases) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Empty State for Dashboard
struct EmptyStateDashboardView: View {
    var onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "hand.raised.fill")
                .font(.system(size: 64))
                .foregroundColor(Theme.Colors.tertiaryText)
            
            Text("No transactions yet")
                .font(Theme.Typography.title3)
                .foregroundColor(Theme.Colors.primaryText)
            
            Button(action: onAdd) {
                Text("Add Your First Expense")
                    .font(Theme.Typography.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(Theme.Colors.primary)
                    .cornerRadius(Theme.CornerRadius.lg)
            }
        }
        .padding(.vertical, Theme.Spacing.xxl)
    }
}

// MARK: - Spending Summary Card
struct SpendingSummaryCard: View {
    let totalSpent: Double
    let budget: Double?
    let progress: Double
    
    var formattedSpent: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: totalSpent)) ?? "₹0"
    }
    
    var formattedBudget: String {
        guard let budget = budget else { return "No budget set" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: budget)) ?? "₹0"
    }
    
    var statusColor: Color {
        if budget == nil { return Theme.Colors.primary }
        if progress >= 1.0 { return Theme.Colors.danger }
        if progress >= 0.8 { return Theme.Colors.warning }
        return Theme.Colors.success
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Spend & Budget Info
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Spent this month")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.secondaryText)
                        .textCase(.uppercase)
                    
                    Text(formattedSpent)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(statusColor)
                }
                
                Spacer()
                
                if let _ = budget {
                    CircularProgressView(progress: progress, color: statusColor)
                        .frame(width: 50, height: 50)
                }
            }
            
            // Budget Progress
            if let budgetAmount = budget {
                VStack(spacing: Theme.Spacing.sm) {
                    // Progress Bar
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.full)
                            .fill(Theme.Colors.tertiaryBackground)
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.full)
                            .fill(statusColor)
                            .frame(width: max(0, min(1.0, progress)) * (UIScreen.main.bounds.width - 80), height: 8)
                            .animation(.spring(), value: progress)
                    }
                    
                    HStack {
                        Text("\(formattedBudget) Budget")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.secondaryText)
                        
                        Spacer()
                        
                        Text("\(Int(progress * 100))%")
                            .font(Theme.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(statusColor)
                    }
                }
            } else {
                HStack {
                    Image(systemName: "info.circle")
                    Text("No budget set for this month")
                }
                .font(Theme.Typography.footnote)
                .foregroundColor(Theme.Colors.secondaryText)
                .padding(.vertical, 4)
            }
        }
        .padding(Theme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xl)
                .fill(Theme.Colors.secondaryBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.xl)
                        .stroke(Theme.Colors.cardBorder.opacity(0.5), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(Theme.Premium.shadowOpacity), radius: Theme.Premium.shadowRadius, y: 5)
    }
}

// MARK: - Circular Progress View
struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

// Preview removed due to @Query private initializer
