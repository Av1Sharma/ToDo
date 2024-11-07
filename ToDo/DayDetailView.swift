import SwiftUI

struct DayDetailView: View {
    var day: Date
    @StateObject private var taskManager = TaskManager()
    @State private var showAddTask = false

    // Calculate the start of the week for the given day once and reuse it
    private var weekStart: Date {
        taskManager.startOfWeek(for: day)
    }

    var body: some View {
        VStack {
            // Progress bar
            let tasksForToday = taskManager.tasksForWeek[weekStart] ?? []
            let progress = tasksForToday.isEmpty ? 0.0 : Double(tasksForToday.filter { $0.isCompleted }.count) / Double(tasksForToday.count)
            ProgressView(value: progress, total: 1)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()

            // Task list
            List {
                // Binding to the array of tasks
                ForEach(Array(tasksForToday.enumerated()), id: \.offset) { index, task in
                    HStack {
                        // Task completion button with animation
                        Button(action: {
                            withAnimation {
                                taskManager.tasksForWeek[weekStart]?[index].isCompleted.toggle() // Toggle completion
                            }
                            taskManager.saveTasks(for: weekStart) // Save changes
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

            // Add task button
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
                        set: { taskManager.tasksForWeek[weekStart] = $0 }
                    ),
                    onDismiss: {
                        taskManager.saveTasks(for: weekStart) // Save tasks when returning from AddTaskView
                    }
                )
            }
        }
        .onAppear {
            taskManager.loadTasks(for: weekStart) // Load tasks for the current week
        }
        .onDisappear {
            taskManager.saveTasks(for: weekStart) // Save tasks when leaving the view
        }
        .navigationBarTitle(Text("Tasks for \(formattedDate(day))"), displayMode: .inline)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
