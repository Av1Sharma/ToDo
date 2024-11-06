import SwiftUICore
import SwiftUI
struct ContentView: View {
    @StateObject private var viewModel = WeeklyTasksViewModel()
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Week", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                NavigationLink(destination: WeekTasksView(viewModel: viewModel, selectedWeek: selectedDate)) {
                    Text("View To-Do List for Week")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Weekly To-Do List")
        }
    }
}

#Preview {
    ContentView()
}
