import SwiftUI

struct AddTaskView: View {
    @Binding var tasks: [Task]
    @State private var taskName = ""
    @State private var dueDate: Date = Date()
    @State private var isHighPriority = false
    @State private var taskColor: Color = .blue
    @Environment(\.presentationMode) var presentationMode

    var onDismiss: () -> Void

    var body: some View {
        VStack {
            TextField("Enter task name", text: $taskName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                .padding()

            Toggle("High Priority", isOn: $isHighPriority)
                .padding()

            ColorPicker("Select Color", selection: $taskColor)
                .padding()

            Button("Add Task") {
                let newTask = Task(name: taskName, dueDate: dueDate, isHighPriority: isHighPriority, color: taskColor)
                tasks.append(newTask)
                taskName = ""
                dueDate = Date()
                isHighPriority = false
                taskColor = .blue
                onDismiss()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .disabled(taskName.isEmpty)
        }
        .padding()
    }
}
