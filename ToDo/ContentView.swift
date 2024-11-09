import SwiftUI

struct ContentView: View {
    @StateObject private var taskManager = TaskManager()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CalendarView(taskManager: taskManager)) {
                    Text("Calendar View")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: TaskListView(taskManager: taskManager)) {
                    Text("Task List View")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("ToDo App")
            .padding()
        }
    }
}
