import SwiftUI

struct DayDetailView: View {
    var day: Date
    @StateObject private var taskManager = TaskManager()
    @State private var showAddTask = false

    private var weekStart: Date {
        taskManager.startOfWeek(for: day)
    }

    var body: some View {
        VStack {
            let tasksForToday = taskManager.tasksForWeek[weekStart] ?? []
            let progress = tasksForToday.isEmpty ? 0.0 : Double(tasksForToday.filter { $0.isCompleted }.count) / Double(tasksForToday.count)
            ProgressView(value: progress, total: 1)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()

            List {
                ForEach(Array(tasksForToday.enumerated()), id: \.offset) { index, task in
                    HStack {
                        Button(action: {
                            withAnimation {
                                taskManager.tasksForWeek[weekStart]?[index].isCompleted.toggle()
                            }
                            taskManager.saveTasks(for: weekStart)
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                .foregroundColor(task.isCompleted ? .green : .blue)
                        }

                        Text(task.name)
                            .strikethrough(task.isCompleted, color: .black)
                            .foregroundColor(task.isCompleted ? .gray : .black)
                        
                        if let color = task.color {
                            Circle()
                                .fill(color)
                                .frame(width: 10, height: 10)
                        }
                        
                        if let dueDate = task.dueDate {
                            Text("Due: \(formattedDate(dueDate))")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                    }
                }
            }

            Button(action: { showAddTask.toggle() }) {
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
        .navigationBarTitle(Text("Tasks for \(formattedDate(day))"), displayMode: .inline)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
