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

## Installation on Physical Device

To install the app on your iPhone:

1. **Connect your iPhone** to your Mac via cable or Wi-Fi.
2. **Select your Device** in the Xcode target selector (next to the Play button).
3. **Configure Signing**:
   - Go to the **ExpenseTracker** project settings in the sidebar.
   - Select the **ExpenseTracker** target.
   - Go to the **Signing & Capabilities** tab.
   - Select your "Team" (your Apple ID).
   - Change the **Bundle Identifier** to something unique if required (e.g., `com.yourname.ExpenseTracker`).
4. **Trust the Certificate**:
   - Once the app builds and installs, it might not open immediately.
   - On your iPhone, go to **Settings > General > VPN & Device Management**.
   - Tap on your Apple ID under "Developer App".
   - Tap **Trust [Your Apple ID]**.

### ⚠️ Important: Reinstallation Requirement (7-Day Limit)

If you are using a **free Apple Developer account** (signing with your personal Apple ID without a paid membership):

- The app certificate is only valid for **7 days**.
- After 7 days, the app will crash or show "Unable to Verify App" when you try to open it.
- **To fix this**: Simply reconnect your iPhone to your Mac and **Run (`Cmd + R`)** the project again from Xcode. This will renew the certificate for another 7 days.
- **Note**: Your data will **not** be lost during this reinstallation as it is stored locally on the device.

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
