import SwiftUI

/// Unique visual identity for Groundcheck - Site Survey Log.
enum Theme {
    static let accent = Color(red: 0.3569, green: 0.4588, blue: 0.3255)
    static let background = Color(red: 0.0588, green: 0.0784, blue: 0.0627)
    static let textPrimary = Color(red: 0.9333, green: 0.9529, blue: 0.9255)
    static let card = background.opacity(0.6)

    static let titleFont = Font.system(.title2, design: .serif).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static func statusColor(_ status: String) -> Color {
        switch status {
        case "Draft": return accent
        case "Quoted": return .gray
        default: return accent.opacity(0.7)
        }
    }
}
