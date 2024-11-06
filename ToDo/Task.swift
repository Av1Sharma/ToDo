import SwiftUI

struct Task: Identifiable {
    var id = UUID()
    var name: String
    var isCompleted: Bool = false
}

class WeeklyTasksViewModel: ObservableObject {
    // Dictionary mapping each week's start date to a list of tasks
    @Published var tasksByWeek: [Date: [Task]] = [:]
    
    // Function to get tasks for a specific week without modifying the dictionary
    func getTasks(forWeekOf date: Date) -> [Task] {
        let weekStart = getStartOfWeek(date: date)
        // Return the tasks if they exist, otherwise return an empty array
        return tasksByWeek[weekStart] ?? []
    }
    
    // Function to initialize a new week if it doesn’t exist
    func initializeWeek(for date: Date) {
        let weekStart = getStartOfWeek(date: date)
        if tasksByWeek[weekStart] == nil {
            tasksByWeek[weekStart] = []
        }
    }
    
    func addTask(forWeekOf date: Date, taskName: String) {
        let weekStart = getStartOfWeek(date: date)
        let newTask = Task(name: taskName)
        tasksByWeek[weekStart, default: []].append(newTask)
    }
    
    // Helper to calculate the start of the week
    public func getStartOfWeek(date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: calendar.dateInterval(of: .weekOfYear, for: date)!.start)
    }
}
