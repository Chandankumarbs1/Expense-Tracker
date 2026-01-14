import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)
            
            ExpenseListView()
                .tabItem {
                    Label("Expenses", systemImage: "tray.full.fill")
                }
                .tag(1)
            
            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: "indianrupeesign.circle.fill")
                }
                .tag(2)
        }
        .tint(Theme.Colors.primary)
        .onAppear {
            // Modern TabBar Appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().standardAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}
