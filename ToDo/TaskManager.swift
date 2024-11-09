import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasksForWeek: [Date: [Task]] = [:]
    
    func loadTasks(for weekStart: Date) {
        let weekStartString = formattedDate(weekStart)
        if let data = UserDefaults.standard.data(forKey: weekStartString),
           let loadedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            self.tasksForWeek[weekStart] = loadedTasks
        }
    }
    
    func saveTasks(for weekStart: Date) {
        if let tasks = tasksForWeek[weekStart],
           let data = try? JSONEncoder().encode(tasks) {
            let weekStartString = formattedDate(weekStart)
            UserDefaults.standard.set(data, forKey: weekStartString)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
