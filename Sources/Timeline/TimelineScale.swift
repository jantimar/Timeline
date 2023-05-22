import Foundation

public struct TimelineScale {
    /// Name of timeline scale
    public var title: String
    /// Time interval visible in one moment ( from leading to trailing )
    public var timeInterval: TimeInterval
    /// On how many chunks should be split one time interval ( will be used for background gird)
    public var numberOfChunks: Int

    public init(
        title: String,
        timeInterval: TimeInterval,
        numberOfChunks: Int
    ) {
        self.title = title
        self.timeInterval = timeInterval
        self.numberOfChunks = numberOfChunks
    }
}

public extension TimelineScale {
    static let halfDay = TimelineScale(
        title: "12 h",
        timeInterval: 12 * 60 * 60,
        numberOfChunks: 12
    )

    static let day = TimelineScale(
        title: "24 h",
        timeInterval: 24 * 60 * 60,
        numberOfChunks: 24
    )

    static let week = TimelineScale(
        title: "7 d",
        timeInterval: 168 * 60 * 60,
        numberOfChunks: 7
    )
}
