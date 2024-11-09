import SwiftUI

struct CalendarTaskIndicator: View {
    var date: Date
    var tasks: [Task]

    var body: some View {
        VStack {
            if let taskForSelectedDate = tasks.first(where: { Calendar.current.isDate($0.dueDate ?? Date(), inSameDayAs: date) }) {
                HStack {
                    Circle()
                        .fill(taskForSelectedDate.taskColor()) // Use task color for the dot
                        .frame(width: 5, height: 5)
                    Text("Due: \(taskForSelectedDate.name)")
                        .font(.footnote)
                }
            } else {
                Text("No tasks due on this date.")
                    .font(.footnote)
            }
        }
    }
}

struct CalendarTaskIndicator_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTaskIndicator(date: Date(), tasks: [Task(name: "Task", dueDate: Date(), isHighPriority: false, color: .blue)])
    }
}
