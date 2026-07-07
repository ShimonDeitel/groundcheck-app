import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Item] = []
    @Published var isPro: Bool = false

    /// Free tier item cap. Deliberately set above the seed-data count so a
    /// fresh install never hits the paywall immediately.
    let freeLimit = 20

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("groundcheck_items.json")
    }()

    init() {
        load()
    }

    var isAtFreeLimit: Bool {
        !isPro && items.count >= freeLimit
    }

    func add(_ item: Item) -> Bool {
        guard !isAtFreeLimit else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: Item) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Item) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Item].self, from: data) {
            items = decoded
        } else {
            items = [
            Item(field1: "142 Birch Rd", field2: "Uneven grade, needs drainage", status: "Ready to Quote"),
            Item(field1: "88 Maple Ave", field2: "Standard lot, easy access", status: "Quoted"),
            Item(field1: "6 Quarry Ln", field2: "Rocky soil, may need excavation", status: "Draft"),
            Item(field1: "310 Elm Ct", field2: "Tree roots near foundation", status: "Ready to Quote"),
            Item(field1: "22 Cedar Way", field2: "Tight access, no truck room", status: "Draft")
            ]
            save()
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
