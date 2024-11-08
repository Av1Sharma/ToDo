import SwiftUI

// CodableColor struct to make Color Codable by encoding its RGB components
struct CodableColor: Codable {
    var red: Double
    var green: Double
    var blue: Double

    init(color: Color) {
        let components = color.cgColor?.components ?? [0, 0, 0]
        self.red = Double(components[0])
        self.green = Double(components[1])
        self.blue = Double(components[2])
    }

    // Convert CodableColor back to Color
    func toColor() -> Color {
        return Color(red: red, green: green, blue: blue)
    }
}

enum TaskPriority: String, Codable {
    case low
    case medium
    case high
}

struct Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var isCompleted: Bool = false
    var dueDate: Date? // Optional due date
    var isHighPriority: Bool = false // Is task high priority?
    var color: CodableColor // The task's color
    
    // Initializer for creating a Task
    init(name: String, dueDate: Date? = nil, isHighPriority: Bool = false, color: Color = .blue) {
        self.name = name
        self.dueDate = dueDate
        self.isHighPriority = isHighPriority
        self.color = CodableColor(color: color) // Convert Color to CodableColor
    }

    // Convert the CodableColor back to Color for display
    func taskColor() -> Color {
        return color.toColor()
    }

    // Function to set priority color (for calendar view)
    func priorityColor() -> Color {
        switch isHighPriority {
        case true:
            return .red
        case false:
            return .green
        }
    }

    // Check if task is due today
    func isDueToday() -> Bool {
        guard let dueDate = dueDate else { return false }
        let calendar = Calendar.current
        return calendar.isDateInToday(dueDate)
    }
}
