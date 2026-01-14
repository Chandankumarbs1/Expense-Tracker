import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Expense.self,
            Category.self,
            Budget.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Initialize predefined categories if needed
            let context = container.mainContext
            let descriptor = FetchDescriptor<Category>()
            let existingCategories = try? context.fetch(descriptor)
            
            if existingCategories?.isEmpty ?? true {
                for category in Category.predefinedCategories {
                    context.insert(category)
                }
                try? context.save()
            }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.theme.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}
