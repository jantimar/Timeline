import Foundation

struct TestItem: TimelineItem {
    let id: Int = UUID().hashValue
    var start: Date = .now
    var end: Date = .now
    var isContinous: Bool = true
    var text: String
}
