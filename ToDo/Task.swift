import SwiftUI

struct Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var isCompleted: Bool = false
    var dueDate: Date? // Optional due date
    var isHighPriority: Bool = false
    var color: CodableColor // The task's color

    init(name: String, dueDate: Date? = nil, isHighPriority: Bool = false, color: Color = .blue) {
        self.name = name
        self.dueDate = dueDate
        self.isHighPriority = isHighPriority
        self.color = CodableColor(color: color)
    }

    func taskColor() -> Color {
        return color.toColor()
    }

    func priorityColor() -> Color {
        return isHighPriority ? .red : .green
    }

    func isDueToday() -> Bool {
        guard let dueDate = dueDate else { return false }
        let calendar = Calendar.current
        return calendar.isDateInToday(dueDate)
    }
}

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

    func toColor() -> Color {
        return Color(red: red, green: green, blue: blue)
    }
}
