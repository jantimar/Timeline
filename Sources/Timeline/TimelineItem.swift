import Foundation

public protocol TimelineItem {
    var id: Int { get }
    var start: Date { get }
    var end: Date { get }
    var isContinous: Bool { get }

    var text: String { get }
}
