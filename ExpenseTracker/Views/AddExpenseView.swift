import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var categories: [Category]
    
    var expenseToEdit: Expense?
    
    @State private var amount: String = ""
    @State private var selectedCategory: Category?
    @State private var date: Date = Date()
    @State private var notes: String = ""
    @State private var showError: Bool = false
    
    var isEditing: Bool {
        expenseToEdit != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Amount") {
                    HStack {
                        Text("₹")
                            .font(Theme.Typography.title2)
                            .foregroundColor(Theme.Colors.primary)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(Theme.Typography.title2)
                    }
                }
                
                Section("Category") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.Spacing.md) {
                            ForEach(categories) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory?.id == category.id
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.vertical, Theme.Spacing.sm)
                    }
                }
                
                Section("Date") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Expense" : "Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Update" : "Save") {
                        saveExpense()
                    }
                    .fontWeight(.semibold)
                }
            }
            .alert("Invalid Amount", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid amount greater than 0")
            }
            .onAppear {
                if let expense = expenseToEdit {
                    amount = String(format: "%.2f", expense.amount)
                    selectedCategory = expense.category
                    date = expense.date
                    notes = expense.notes
                } else if selectedCategory == nil {
                    selectedCategory = categories.first
                }
            }
        }
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            showError = true
            return
        }
        
        if let expense = expenseToEdit {
            // Update existing expense
            expense.amount = amountValue
            expense.category = selectedCategory
            expense.date = date
            expense.notes = notes
        } else {
            // Create new expense
            let newExpense = Expense(
                amount: amountValue,
                category: selectedCategory,
                date: date,
                notes: notes
            )
            modelContext.insert(newExpense)
        }
        
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Category Button Component
struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(Color(hex: category.colorHex).opacity(isSelected ? 1.0 : 0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .white : Color(hex: category.colorHex))
                }
                
                Text(category.name)
                    .font(Theme.Typography.caption)
                    .foregroundColor(isSelected ? Theme.Colors.primary : Theme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80)
            }
        }
        .buttonStyle(.plain)
    }
}

// Preview removed due to @Query private initializer
