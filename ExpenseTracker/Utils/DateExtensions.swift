import Foundation

extension Date {
    // Format date as "dd MMM yyyy" (e.g., "14 Jan 2026")
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: self)
    }
    
    // Format date as "MMMM yyyy" (e.g., "January 2026")
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
    
    // Get start of day
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    // Get start of month
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    // Get end of month
    var endOfMonth: Date {
        let calendar = Calendar.current
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self)),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            return self
        }
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfMonth) ?? self
    }
    
    // Check if date is in current month
    var isInCurrentMonth: Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    // Check if two dates are on the same day
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
}
