//
//  TaskManager.swift
//  ToDo
//
//  Created by Avi Sharma on 11/26/24.
//


import Combine

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    
    func addTask(name: String, description: String) {
        let newTask = Task(name: name, description: description, progress: 0.0, isCompleted: false)
        tasks.append(newTask)
    }
    
    func removeCompletedTasks() {
        tasks.removeAll { $0.isCompleted }
    }
}
