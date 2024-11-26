//
//  TaskListView.swift
//  ToDo
//
//  Created by Avi Sharma on 11/26/24.
//


import SwiftUI

struct TaskListView: View {
    @StateObject private var taskManager = TaskManager()
    @State private var showTaskForm = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(taskManager.tasks) { task in
                    if !task.isCompleted {
                        NavigationLink(destination: TaskDetailView(task: task, taskManager: taskManager)) {
                            HStack {
                                Text(task.name)
                                Spacer()
                                ProgressView(value: task.progress)
                                    .frame(width: 100)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("To-Do List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showTaskForm.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showTaskForm) {
                AddTaskView(taskManager: taskManager)
            }
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            taskManager.tasks[index].isCompleted = true
        }
        taskManager.removeCompletedTasks()
    }
}
