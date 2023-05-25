import Foundation

public protocol TimelineItem {
    /// Time when Item start in timeline
    var start: Date { get }
    /// Time when Ite finish in timeline
    var end: Date { get }
    /// Text for show in item
    var text: String { get }
}
