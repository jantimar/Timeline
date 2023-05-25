import Foundation

public final class TimelineGridViewModel: ObservableObject {

    @Published var scale: TimelineScale
    @Published var chunks: [Chunk]

    let minimalDate: Date
    let maximalDate: Date

    init(
        scale: TimelineScale,
        minimalDate: Date,
        maximalDate: Date
    ) {
        self.scale = scale
        self.minimalDate = minimalDate
        self.maximalDate = maximalDate

        // Setup chunks for grid
        let numberOfChunks = Int((maximalDate.timeIntervalSince(minimalDate)) / scale.timeInterval * CGFloat(scale.numberOfChunks) + 2)
        let startDate: Date
        let dateFormatter = DateFormatter()

        let hour: TimeInterval = 60 * 60
        let day: TimeInterval = 24 * hour

        switch scale {
        case .halfDay, .day:
            let components = Calendar.current.dateComponents([.hour, .day, .month, .year], from: minimalDate)
            startDate = Calendar.current.date(from: components) ?? Date()
            dateFormatter.dateFormat = "hh"
        default:
            let components = Calendar.current.dateComponents([.day, .month, .year], from: minimalDate)
            startDate = Calendar.current.date(from: components) ?? Date()
            dateFormatter.dateFormat = "dd/MM"
        }

        self.chunks = (0...numberOfChunks).compactMap { index in
            var date: Date
            switch scale {
            case .halfDay, .day:
                date = Date(timeInterval: TimeInterval(index) * hour, since: startDate)
            default:
                date = Date(timeInterval: TimeInterval(index) * day, since: startDate)
            }

            let title = dateFormatter.string(from: date)
            return Chunk(date: date, title: title)
        }
    }
}

// MARK: - Helper for calculate offsets and widths
extension TimelineGridViewModel {
    func horizontalOffset(for date: Date, width: CGFloat) -> CGFloat {
        widthBetween(minimalDate, and: date, width: width)
    }

    func widthBetween(_ date1: Date, and date2: Date, width: CGFloat) -> CGFloat {
        let chunk = width / scale.timeInterval
        let timeIntervalOffset = date2.timeIntervalSince(date1)
        return chunk * timeIntervalOffset
    }
}
