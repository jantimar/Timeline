import Foundation

public final class TimelineViewModel: ObservableObject {

    @Published var scale: TimelineScale
    @Published var items: [[TimelineItem]]

    let minimalDate: Date
    let maximalDate: Date

    /// Initialize ViewModel for TimelineView
    /// - Parameters:
    ///   - scale: Current scale of timeline, define time visible per view in one moment, default value is `day`
    ///   - items: 2 dimensions rows wher firs array is rows and second dimension is items in current row
    public init(
        scale: TimelineScale = .day,
        items: [[TimelineItem]]
    ) {
        self.scale = scale
        self.items = items

        // Setup edge dates
        var minimalDate: Date?
        var maximalDate: Date?

        for rows in items {
            for item in rows {
                minimalDate = (minimalDate ?? item.start) < item.start ? minimalDate : item.start
                maximalDate = (maximalDate ?? item.end) > item.end ? maximalDate : item.end
            }
        }
        self.maximalDate = maximalDate ?? Date()

        self.minimalDate = min(
            minimalDate ?? Date(),
            maximalDate?.addingTimeInterval(-scale.timeInterval) ?? Date()
        )
    }
}

// MARK: - Helper for calculate offsets and widths
extension TimelineViewModel {
    func horizontalOffset(for date: Date, width: CGFloat) -> CGFloat {
        widthBetween(minimalDate, and: date, width: width)
    }

    func widthBetween(_ date1: Date, and date2: Date, width: CGFloat) -> CGFloat {
        let chunk = width / scale.timeInterval
        let timeIntervalOffset = date2.timeIntervalSince(date1)
        return chunk * timeIntervalOffset
    }
}
