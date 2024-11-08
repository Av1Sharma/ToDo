import Foundation
import SwiftUI

struct Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var color: Color?
    var isHighPriority: Bool = false

    // Explicit initializer with default values for optional parameters
    init(name: String, isCompleted: Bool = false, dueDate: Date? = nil, color: Color? = nil, isHighPriority: Bool = false) {
        self.name = name
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.color = color
        self.isHighPriority = isHighPriority
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, isCompleted, dueDate, color, isHighPriority
    }
    
    // Custom encoding and decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        isHighPriority = try container.decode(Bool.self, forKey: .isHighPriority)
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        
        if let colorHex = try container.decodeIfPresent(String.self, forKey: .color) {
            color = Color(hex: colorHex)
        } else {
            color = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(isHighPriority, forKey: .isHighPriority)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
        
        if let color = color {
            try container.encode(color.toHex(), forKey: .color)
        }
    }
}

extension Color {
    init?(hex: String) {
        guard let rgb = Int(hex, radix: 16) else { return nil }
        self = Color(
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }

    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb = (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
        return String(format: "%06X", rgb)
    }
}
