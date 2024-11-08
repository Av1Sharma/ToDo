import Foundation

class TaskManager: ObservableObject {
    @Published var tasksForWeek: [Date: [Task]] = [:]
    
    func loadTasks(for weekStart: Date) {
        let previousWeekStart = startOfPreviousWeek(for: weekStart)
        carryOverUnfinishedTasks(from: previousWeekStart, to: weekStart)
        
        let weekStartString = formattedDate(weekStart)
        if let data = UserDefaults.standard.data(forKey: weekStartString),
           let loadedTasks = try? JSONDecoder().decode([Date: [Task]].self, from: data) {
            self.tasksForWeek = loadedTasks
            print("Loaded tasks for the week starting \(weekStartString)")
        } else {
            print("No saved tasks found for the week starting \(weekStartString)")
        }
    }
    
    func saveTasks(for weekStart: Date) {
        let weekStartString = formattedDate(weekStart)
        if let data = try? JSONEncoder().encode(tasksForWeek) {
            UserDefaults.standard.set(data, forKey: weekStartString)
            print("Saved tasks for the week starting \(weekStartString)")
        }
    }
    
    func startOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
    }
    
    private func startOfPreviousWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        let currentWeekStart = startOfWeek(for: date)
        return calendar.date(byAdding: .day, value: -7, to: currentWeekStart)!
    }
    
    private func carryOverUnfinishedTasks(from previousWeekStart: Date, to newWeekStart: Date) {
        print("Carrying over unfinished tasks from \(formattedDate(previousWeekStart)) to \(formattedDate(newWeekStart))")
        
        let previousWeekTasks = tasksForWeek[previousWeekStart] ?? []
        let unfinishedTasks = previousWeekTasks.filter { !$0.isCompleted }
        
        if !unfinishedTasks.isEmpty {
            print("Unfinished tasks found: \(unfinishedTasks.count)")
            tasksForWeek[newWeekStart, default: []].append(contentsOf: unfinishedTasks)
            saveTasks(for: newWeekStart)
        } else {
            print("No unfinished tasks to carry over.")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
