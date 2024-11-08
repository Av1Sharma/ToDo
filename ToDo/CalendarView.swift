import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            DatePicker("Select a day", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            NavigationLink(destination: DayDetailView(day: selectedDate)) {
                Text("Go to Tasks for \(formattedDate(selectedDate))")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Calendar")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
