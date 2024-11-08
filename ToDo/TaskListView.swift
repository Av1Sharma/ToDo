import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskManager = TaskManager()
    @State private var showAddTask = false
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            // Task List View
            List {
                ForEach(taskManager.tasksForWeek[selectedDate] ?? [], id: \.id) { task in
                    HStack {
                        Button(action: {
                            toggleTaskCompletion(task)
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                .foregroundColor(task.isCompleted ? .green : .blue)
                        }
                        
                        Text(task.name)
                            .strikethrough(task.isCompleted, color: .black)
                            .foregroundColor(task.isCompleted ? .gray : .black)
                    }
                }
            }

            Button(action: {
                showAddTask.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            .padding()
            .sheet(isPresented: $showAddTask) {
                // Pass a Binding<[Task]> to the AddTaskView
                AddTaskView(
                    tasks: Binding(
                        get: { taskManager.tasksForWeek[selectedDate] ?? [] },
                        set: { taskManager.tasksForWeek[selectedDate] = $0 }
                    ),
                    onDismiss: {
                        taskManager.saveTasks(for: selectedDate) // Save tasks when the sheet is dismissed
                    }
                )
            }
        }
        .onAppear {
            taskManager.loadTasks(for: selectedDate)
        }
        .onDisappear {
            taskManager.saveTasks(for: selectedDate)
        }
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = taskManager.tasksForWeek[selectedDate]?.firstIndex(where: { $0.id == task.id }) {
            taskManager.tasksForWeek[selectedDate]?[index].isCompleted.toggle()
            taskManager.saveTasks(for: selectedDate)
        }
    }
}
