//
//  TaskDetailView.swift
//  ToDo
//
//  Created by Avi Sharma on 11/26/24.
//


import SwiftUI

struct TaskDetailView: View {
    @State var task: Task
    @ObservedObject var taskManager: TaskManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text(task.description)
                .font(.headline)
                .padding()
            
            ProgressView("Progress", value: task.progress)
                .padding()
            
            HStack {
                Button("Increase Progress") {
                    task.progress = min(task.progress + 0.25, 1.0)
                    updateTask()
                }
                .padding()
                
                Button("Mark as Complete") {
                    task.isCompleted = true
                    updateTask()
                }
                .padding()
            }
        }
        .navigationTitle(task.name)
        .padding()
    }
    
    private func updateTask() {
        if let index = taskManager.tasks.firstIndex(where: { $0.id == task.id }) {
            taskManager.tasks[index] = task
        }
    }
}
