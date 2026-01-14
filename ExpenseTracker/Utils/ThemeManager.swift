import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("appTheme") var theme: AppTheme = .system
    
    enum AppTheme: String, CaseIterable, Identifiable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
        
        var id: String { self.rawValue }
        
        var colorScheme: ColorScheme? {
            switch self {
            case .light: return .light
            case .dark: return .dark
            case .system: return nil
            }
        }
    }
}
