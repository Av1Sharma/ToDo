import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @ObservedObject var taskManager: TaskManager

    var body: some View {
        NavigationView {
            VStack {
                // Calendar view (simple date picker for now)
                DatePicker("Select a day", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                // Navigation to tasks for selected day
                NavigationLink(destination: DayDetailView(day: selectedDate, taskManager: taskManager)) {
                    Text("Go to Tasks for \(formattedDate(selectedDate))")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Render Calendar with Task Indicators
                CalendarWithIndicators(tasks: taskManager.tasksForWeek)
            }
            .navigationTitle("Calendar")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct CalendarWithIndicators: View {
    var tasks: [Date: [Task]]

    var body: some View {
        let daysInMonth = daysInCurrentMonth()

        VStack {
            HStack {
                ForEach(daysInMonth, id: \.self) { date in
                    VStack {
                        Text("\(getDayOfMonth(date))")
                            .frame(width: 30, height: 30)
                            .background(Color.clear)
                            .cornerRadius(5)
                            .overlay(
                                Circle()
                                    .fill(hasTasksForDate(date) ? Color.blue : Color.clear)
                                    .frame(width: 5, height: 5)
                                    .offset(x: 0, y: 15) // Adjust the position of the dot
                            )
                    }
                }
            }
        }
    }

    // Helper function to get days of the current month
    private func daysInCurrentMonth() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let range = calendar.range(of: .day, in: .month, for: today)!
        return range.map { calendar.date(byAdding: .day, value: $0 - 1, to: calendar.startOfDay(for: today))! }
    }

    // Helper function to get day of month
    private func getDayOfMonth(_ date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }

    // Helper function to check if tasks exist for the date
    private func hasTasksForDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return tasks.keys.contains { calendar.isDate($0, inSameDayAs: date) }
    }
}

