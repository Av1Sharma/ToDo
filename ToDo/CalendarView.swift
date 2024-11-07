//
//  CalendarView.swift
//  ToDo
//
//  Created by Avi Sharma on 11/6/24.
//


import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            VStack {
                // Calendar view (simple date picker for now)
                DatePicker("Select a day", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                // Navigate to tasks for selected day
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
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
