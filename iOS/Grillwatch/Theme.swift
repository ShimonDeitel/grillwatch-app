import SwiftUI

enum Theme {
    static let accent = Color(red: 0.85, green: 0.30, blue: 0.15)
    static let background = Color(red: 0.10, green: 0.05, blue: 0.03)
    static let cardBackground = Color(.secondarySystemGroupedBackground)
    static let titleFont: Font = .system(.title2, design: .rounded).weight(.bold)
    static let bodyFont: Font = .system(.body, design: .rounded)
    static let captionFont: Font = .system(.caption, design: .rounded)
}
