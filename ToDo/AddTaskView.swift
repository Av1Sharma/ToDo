import SwiftUI

struct AddTaskView: View {
    @Binding var tasks: [Task]
    @State private var taskName = ""
    @State private var dueDate: Date? = nil
    @State private var isHighPriority = false
    @State private var taskColor: Color = .blue
    @Environment(\.presentationMode) var presentationMode

    var onDismiss: () -> Void

    var body: some View {
        VStack {
            TextField("Enter task name", text: $taskName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Use a default value if dueDate is nil
            DatePicker("Due Date", selection: Binding(
                get: { dueDate ?? Date() }, // Provide a default value if nil
                set: { dueDate = $0 }         // Update the dueDate when changed
            ), displayedComponents: .date)
            .padding()

            Toggle("High Priority", isOn: $isHighPriority)
                .padding()

            ColorPicker("Pick a color", selection: $taskColor)
                .padding()

            Button("Add Task") {
                let newTask = Task(name: taskName, dueDate: dueDate, isHighPriority: isHighPriority, color: taskColor)
                tasks.append(newTask)
                taskName = "" // Reset the text field
                onDismiss() // Save tasks
                presentationMode.wrappedValue.dismiss() // Dismiss the sheet
            }
            .padding()
            .disabled(taskName.isEmpty)
        }
        .padding()
    }
}
