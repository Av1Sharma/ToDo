import SwiftUI

struct DayDetailView: View {
    var day: Date
    @ObservedObject var taskManager = TaskManager()
    @State private var showAddTask = false

    private var weekStart: Date {
        taskManager.startOfWeek(for: day)
    }

    var body: some View {
        VStack {
            // Task List View
            List {
                ForEach(taskManager.tasksForWeek[weekStart] ?? [], id: \.id) { task in
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
                AddTaskView(tasks: Binding(get: { taskManager.tasksForWeek[weekStart] ?? [] }, set: { taskManager.tasksForWeek[weekStart] = $0 }), onDismiss: {
                    taskManager.saveTasks(for: weekStart)
                })
            }
        }
        .onAppear {
            taskManager.loadTasks(for: weekStart)
        }
        .onDisappear {
            taskManager.saveTasks(for: weekStart)
        }
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = taskManager.tasksForWeek[weekStart]?.firstIndex(where: { $0.id == task.id }) {
            taskManager.tasksForWeek[weekStart]?[index].isCompleted.toggle()
            taskManager.saveTasks(for: weekStart)
        }
    }
}
