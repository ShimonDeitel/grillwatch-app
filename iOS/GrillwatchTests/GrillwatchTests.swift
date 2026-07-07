import XCTest
@testable import Grillwatch

@MainActor
final class GrillwatchTests: XCTestCase {
    func testSeedDataBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    func testAddEntryIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        store.add(GrillEntry(grillName: "Test", lastCleaned: "Today", tankLevel: "Good"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = Store()
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        let store = Store()
        store.isPro = false
        while store.entries.count < Store.freeLimit {
            store.add(GrillEntry(grillName: "X", lastCleaned: "Y", tankLevel: "Z"))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProEvenAtLimit() {
        let store = Store()
        store.isPro = true
        while store.entries.count < Store.freeLimit {
            store.add(GrillEntry(grillName: "X", lastCleaned: "Y", tankLevel: "Z"))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testDeleteRemovesEntry() {
        let store = Store()
        let entry = GrillEntry(grillName: "ToDelete", lastCleaned: "Today", tankLevel: "Good")
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testUpdateModifiesEntry() {
        let store = Store()
        var entry = GrillEntry(grillName: "Orig", lastCleaned: "Today", tankLevel: "Good")
        store.add(entry)
        entry.grillName = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.grillName, "Updated")
    }

    func testDeleteAtOffsets() {
        let store = Store()
        let before = store.entries.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, before - 1)
    }
}
