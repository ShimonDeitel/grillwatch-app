import Foundation

struct GrillEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var grillName: String
    var lastCleaned: String
    var tankLevel: String
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), grillName: String, lastCleaned: String, tankLevel: String, notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.grillName = grillName
        self.lastCleaned = lastCleaned
        self.tankLevel = tankLevel
        self.notes = notes
        self.createdAt = createdAt
    }
}
