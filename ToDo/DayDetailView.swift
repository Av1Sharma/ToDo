import SwiftUICore
import SwiftUI
import Foundation

struct DayDetailView: View {
    var day: Date
    @ObservedObject var taskManager: TaskManager
    @State private var showAddTask = false

    private var weekStart: Date {
        // Move this calculation to TaskManager class
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: day)) ?? day
    }

    var body: some View {
        VStack {
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
                AddTaskView(
                    tasks: Binding(
                        get: { taskManager.tasksForWeek[weekStart] ?? [] },
                        set: { tasks in
                            taskManager.tasksForWeek[weekStart] = tasks
                        }
                    ),
                    onDismiss: {
                        taskManager.saveTasks(for: weekStart)
                    }
                )
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
        if var tasks = taskManager.tasksForWeek[weekStart],
           let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            taskManager.tasksForWeek[weekStart] = tasks
            taskManager.saveTasks(for: weekStart)
        }
    }
}
