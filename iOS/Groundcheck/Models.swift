import Foundation

struct Item: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var field1: String   // Site address
    var field2: String   // Findings
    var status: String
    var notes: String = ""
    var createdAt: Date = Date()
}

enum Status {
    static let all = ["Draft", "Ready to Quote", "Quoted"]
}
