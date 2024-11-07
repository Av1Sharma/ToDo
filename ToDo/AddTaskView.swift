import SwiftUI

struct AddTaskView: View {
    @Binding var tasks: [Task]
    @State private var taskName = ""
    @Environment(\.presentationMode) var presentationMode

    var onDismiss: () -> Void

    var body: some View {
        VStack {
            TextField("Enter task name", text: $taskName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Add Task") {
                let newTask = Task(name: taskName)
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
