import SwiftUI

struct CalendarTaskIndicator: View {
    var date: Date
    var tasks: [Task]

    var body: some View {
        VStack {
            if let taskForSelectedDate = tasks.first(where: { Calendar.current.isDate($0.dueDate ?? Date(), inSameDayAs: date) }) {
                HStack {
                    // Use the correct method `taskColor()` to get the task color
                    Circle()
                        .fill(taskForSelectedDate.taskColor()) // Fixed method name here
                        .frame(width: 20, height: 20)
                    Text("Due: \(taskForSelectedDate.name)")
                }
            } else {
                Text("No tasks due on this date.")
            }
        }
    }
}

struct CalendarTaskIndicator_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTaskIndicator(date: Date(), tasks: [Task(name: "Task", dueDate: Date(), isHighPriority: false, color: .blue)])
    }
}
