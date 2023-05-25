import Foundation

struct TestItem: TimelineItem, Identifiable {
    let id: Int = UUID().hashValue
    var start: Date = .now
    var end: Date = .now
    var isContinous: Bool = true
    var text: String
}
