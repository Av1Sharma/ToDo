import SwiftUI

struct WeekTasksView: View {
    @ObservedObject var viewModel: WeeklyTasksViewModel
    var selectedWeek: Date
    @State private var newTaskName: String = ""
    
    var body: some View {
        VStack {
            // Header and Progress Bar
            Text("Task Progress")
                .font(.headline)
                .padding(.top)
            
            ProgressView(value: calculateProgress())
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
                .scaleEffect(x: 1, y: 2, anchor: .center)  // Makes the progress bar larger

            // Task List
            List {
                ForEach(viewModel.getTasks(forWeekOf: selectedWeek)) { task in
                    HStack {
                        Button(action: {
                            toggleTaskCompletion(task)
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                        }
                        Text(task.name)
                    }
                }
            }
            
            // Add task section
            HStack {
                TextField("New Task", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    addNewTask()
                }) {
                    Text("Add Task")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.bottom)
        }
        .navigationTitle("Tasks for the Week")
        .onAppear {
            // Ensure tasks are initialized for the selected week
            viewModel.initializeWeek(for: selectedWeek)
        }
        .onTapGesture {
            // Dismiss the keyboard when tapping anywhere outside the keyboard
            dismissKeyboard()
        }
    }
    
    private func toggleTaskCompletion(_ task: Task) {
        DispatchQueue.main.async {
            // Find the index of the task and toggle its completion
            if let index = viewModel.tasksByWeek[viewModel.getStartOfWeek(date: selectedWeek)]?.firstIndex(where: { $0.id == task.id }) {
                viewModel.tasksByWeek[viewModel.getStartOfWeek(date: selectedWeek)]?[index].isCompleted.toggle()
            }
        }
    }
    
    private func addNewTask() {
        guard !newTaskName.isEmpty else { return }
        DispatchQueue.main.async {
            // Add a new task to the selected week
            viewModel.addTask(forWeekOf: selectedWeek, taskName: newTaskName)
            newTaskName = "" // Clear the input field after adding
        }
    }
    
    private func calculateProgress() -> Double {
        let tasks = viewModel.getTasks(forWeekOf: selectedWeek)
        guard !tasks.isEmpty else { return 0 }
        
        let completedTasks = tasks.filter { $0.isCompleted }.count
        return Double(completedTasks) / Double(tasks.count)
    }
    
    private func dismissKeyboard() {
        // Dismiss the keyboard by sending a resign action to the first responder
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
