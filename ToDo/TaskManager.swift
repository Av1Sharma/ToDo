import Foundation

class TaskManager: ObservableObject {
    @Published var tasksForWeek: [Date: [Task]] = [:]
    
    // Load tasks for the entire week
    func loadTasks(for weekStart: Date) {
        let weekStartString = formattedDate(weekStart)
        if let data = UserDefaults.standard.data(forKey: weekStartString),
           let loadedTasks = try? JSONDecoder().decode([Date: [Task]].self, from: data) {
            self.tasksForWeek = loadedTasks
        }
    }
    
    // Save tasks for the entire week
    func saveTasks(for weekStart: Date) {
        let weekStartString = formattedDate(weekStart)
        if let data = try? JSONEncoder().encode(tasksForWeek) {
            UserDefaults.standard.set(data, forKey: weekStartString)
        }
    }
    
    // Helper function to get the start of the week (Sunday)
    func startOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
