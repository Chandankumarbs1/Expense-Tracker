import SwiftUI
import SwiftData

struct ExpenseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse)]) private var expenses: [Expense]
    
    @Query(sort: \Category.name) private var categories: [Category]
    
    @State private var searchText = ""
    @State private var selectedCategory: Category?
    @State private var showingAddExpense = false
    @State private var expenseToEdit: Expense?
    
    var filteredExpenses: [Expense] {
        expenses.filter { expense in
            let matchesSearch = searchText.isEmpty || 
                expense.notes.localizedCaseInsensitiveContains(searchText) ||
                expense.category?.name.localizedCaseInsensitiveContains(searchText) ?? false
            
            let matchesCategory = selectedCategory == nil || expense.category == selectedCategory
            
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Category Filter ScrollView
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.Spacing.sm) {
                            CategoryFilterButton(
                                title: "All",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )
                            
                            ForEach(categories) { category in
                                CategoryFilterButton(
                                    title: category.name,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.vertical, Theme.Spacing.md)
                    }
                    .background(Theme.Colors.secondaryBackground.opacity(0.5))
                    
                    if filteredExpenses.isEmpty {
                        Spacer()
                        VStack(spacing: Theme.Spacing.md) {
                            Image(systemName: "tray.fill")
                                .font(.system(size: 48))
                                .foregroundColor(Theme.Colors.tertiaryText)
                            Text("No expenses found")
                                .font(Theme.Typography.headline)
                                .foregroundColor(Theme.Colors.secondaryText)
                        }
                        Spacer()
                    } else {
                        List {
                            ForEach(filteredExpenses) { expense in
                                ExpenseRow(expense: expense)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, Theme.Spacing.md)
                                    .background(Theme.Colors.cardBackground.opacity(0.6))
                                    .cornerRadius(Theme.CornerRadius.md)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .onTapGesture {
                                        expenseToEdit = expense
                                    }
                            }
                            .onDelete(perform: deleteExpenses)
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Expenses")
            .searchable(text: $searchText, prompt: "Search transactions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Theme.Colors.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
            }
            .sheet(item: $expenseToEdit) { expense in
                AddExpenseView(expenseToEdit: expense)
            }
        }
    }
    
    private func deleteExpenses(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredExpenses[index])
        }
        try? modelContext.save()
    }
}

// MARK: - Expense Row Component
struct ExpenseRow: View {
    let expense: Expense
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            // Category Icon
            if let category = expense.category {
                ZStack {
                    Circle()
                        .fill(Color(hex: category.colorHex).opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: category.colorHex))
                }
            }
            
            // Expense Details
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.category?.name ?? "Uncategorized")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.primaryText)
                
                if !expense.notes.isEmpty {
                    Text(expense.notes)
                        .font(Theme.Typography.subheadline)
                        .foregroundColor(Theme.Colors.secondaryText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Amount
            Text(expense.formattedAmount)
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.danger)
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "tray.fill")
                .font(.system(size: 64))
                .foregroundColor(Theme.Colors.tertiaryText)
            
            Text("No Expenses Yet")
                .font(Theme.Typography.title2)
                .foregroundColor(Theme.Colors.primaryText)
            
            Text("Tap the + button to add your first expense")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.Typography.footnote)
                .fontWeight(isSelected ? .bold : .medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.Colors.primary : Theme.Colors.tertiaryBackground)
                .foregroundColor(isSelected ? .white : Theme.Colors.primaryText)
                .cornerRadius(Theme.CornerRadius.full)
        }
    }
}

// Preview removed due to @Query private initializer
