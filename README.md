# Expense Tracker iOS App

A modern, minimalist personal expense tracker for iPhone with local data storage.

## Features

✨ **Expense Management**
- Add, edit, and delete expenses
- 8 predefined categories with custom icons and colors
- INR currency formatting (₹)
- Date selection and notes

📊 **Dashboard & Analytics**
- Monthly spending overview
- Category-wise breakdown with pie chart
- Recent transactions view
- Budget progress tracking

💰 **Budget Tracking**
- Set monthly budgets
- Visual progress indicators
- Budget vs actual comparison
- Overspending alerts

🎨 **Modern Design**
- Minimalist UI with rounded design system
- Full dark mode support
- Smooth animations and transitions
- Responsive layouts

## Technical Stack

- **Language**: Swift
- **UI Framework**: SwiftUI
- **Data Persistence**: SwiftData (iOS 17+)
- **Charts**: Swift Charts
- **Architecture**: MVVM with SwiftData

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- iPhone or iPad

## Project Structure

```
ExpenseTracker/
├── Models/
│   ├── Expense.swift          # Expense data model
│   ├── Category.swift         # Category data model
│   └── Budget.swift           # Budget data model
├── Views/
│   ├── ContentView.swift      # Main tab navigation
│   ├── DashboardView.swift    # Dashboard with analytics
│   ├── ExpenseListView.swift  # Expense list with search
│   ├── AddExpenseView.swift   # Add/Edit expense form
│   ├── BudgetView.swift       # Budget management
│   └── Components/
│       └── CategoryChartView.swift  # Pie chart component
├── Utils/
│   ├── Theme.swift            # Design system & theme
│   └── DateExtensions.swift   # Date utilities
└── ExpenseTrackerApp.swift    # App entry point
```

## Getting Started

1. Open `ExpenseTracker.xcodeproj` in Xcode
2. Select your target device (iPhone or Simulator)
3. Press `Cmd + R` to build and run

## Data Storage

All data is stored locally on your device using SwiftData. No cloud sync or external servers are used, ensuring complete privacy.

## Categories

The app includes 8 predefined categories:
- 🍽️ Food & Dining
- 🚗 Transport
- 📺 Entertainment
- 🛍️ Shopping
- 📄 Bills & Utilities
- ❤️ Health & Fitness
- 📚 Education
- ⋯ Others

## License

Personal use project.
