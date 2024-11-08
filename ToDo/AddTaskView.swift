import SwiftUI

struct AddTaskView: View {
    @Binding var tasks: [Task]
    @State private var taskName = ""
    @State private var isHighPriority = false
    @State private var dueDate: Date = Date()
    @State private var selectedColor: Color = .blue
    @Environment(\.presentationMode) var presentationMode

    var onDismiss: () -> Void

    var body: some View {
        VStack {
            TextField("Enter task name", text: $taskName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Toggle("High Priority", isOn: $isHighPriority)
                .padding()

            if isHighPriority {
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                ColorPicker("Task Color", selection: $selectedColor)
                    .padding()
            }

            Button("Add Task") {
                let newTask = Task(
                    name: taskName,
                    isCompleted: false,
                    dueDate: isHighPriority ? dueDate : nil,
                    color: isHighPriority ? selectedColor : nil,
                    isHighPriority: isHighPriority
                )

                tasks.append(newTask)
                taskName = ""
                onDismiss()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .disabled(taskName.isEmpty)
        }
        .padding()
    }
}
