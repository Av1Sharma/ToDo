//
//  AddTaskView.swift
//  ToDo
//
//  Created by Avi Sharma on 11/26/24.
//


import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var taskManager: TaskManager
    
    @State private var taskName = ""
    @State private var taskDescription = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $taskName)
                TextField("Task Description", text: $taskDescription)
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        taskManager.addTask(name: taskName, description: taskDescription)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
