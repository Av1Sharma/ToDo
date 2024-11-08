import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasksForWeek: [Date: [Task]] = [:]
    
    // Load tasks for the current week, carrying over unfinished tasks if applicable
    func loadTasks(for weekStart: Date) {
        let weekStartString = formattedDate(weekStart)
        if let data = UserDefaults.standard.data(forKey: weekStartString),
           let loadedTasks = try? JSONDecoder().decode([Date: [Task]].self, from: data) {
            self.tasksForWeek = loadedTasks
            print("Loaded tasks for the week starting \(weekStartString)")
        } else {
            print("No saved tasks found for the week starting \(weekStartString)")
        }
    }
    
    // Save tasks for the entire week
    func saveTasks(for weekStart: Date) {
        let weekStartString = formattedDate(weekStart)
        if let data = try? JSONEncoder().encode(tasksForWeek) {
            UserDefaults.standard.set(data, forKey: weekStartString)
            print("Saved tasks for the week starting \(weekStartString)")
        }
    }

    // Helper function to get the start of the current week (Sunday)
    func startOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start
        return startOfWeek ?? date // return date if nil
    }

    // Helper function to format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
