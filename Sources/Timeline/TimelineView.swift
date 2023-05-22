import SwiftUI

public struct TimelineView: View {

    @ObservedObject private var viewModel: TimelineViewModel

    private let trailingIdentifier: String

    @State private var rowHeight: CGFloat
    @State private var rowOffset: CGFloat

    public var body: some View {
        ScrollViewReader { scrollReader in
            GeometryReader { reader in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            // Add Grid view


                            // Rows
                            rows(width: reader.size.width)
                                .padding(.vertical, rowOffset)
                                .frame(
                                    width: viewModel.widthBetween(
                                        viewModel.minimalDate,
                                        and: viewModel.maximalDate,
                                        width: reader.size.width
                                    )
                                )
                        }

                        // Identifier for scroll on trailing
                        Text("").id(trailingIdentifier)
                    }
                }
            }
            .onAppear {
                scrollReader.scrollTo(trailingIdentifier, anchor: .trailing)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: CGFloat(viewModel.items.count) * (rowHeight + rowOffset) + rowOffset)
    }

    public init(
        trailingIdentifier: String = "time-line-trailing-id",
        rowHeight: CGFloat = 60,
        rowOffset: CGFloat = 10,
        viewModel: TimelineViewModel
    ) {
        self.trailingIdentifier = trailingIdentifier
        self.rowHeight = rowHeight
        self.rowOffset = rowOffset
        self.viewModel = viewModel
    }
}

private extension TimelineView {
    @ViewBuilder
    func rows(width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: rowOffset) {
            // Iterate rows
            ForEach(Array(viewModel.items.enumerated()), id: \.offset) { row in
                ZStack(alignment: .leading) {
                    columns(items: row.element, width: width)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder
    func columns(items: [TimelineItem], width: CGFloat) -> some View {
        // Iterate items in row
        ForEach(items, id: \.id) { item in
            HStack(spacing: 0) {
                TimelineItemView(
                    item: item

                )
                .frame(
                    width: viewModel.widthBetween(
                        item.start,
                        and: item.end,
                        width: width
                    ),
                    height: rowHeight
                )
                .padding(
                    .leading,
                    viewModel.horizontalOffset(
                        for: item.start,
                        width: width
                    )
                )

                Spacer()
            }

            // Add points ( overview under row item )
        }
    }
}

struct TimelineView_Previews: PreviewProvider {

    private struct TestItem: TimelineItem {
        let id: Int = UUID().hashValue
        var start: Date
        var end: Date
        var isContinous: Bool = true
        var text: String
    }

    private static let mockData: [[TestItem]] = [
        // Row 1
        [
            TestItem(
                start: .init(timeIntervalSinceNow: -(hour * 40)),
                end: .init(timeIntervalSinceNow: -(hour * 23)),
                text: "Test1"
            ),
            TestItem(
                start: .init(timeIntervalSinceNow: -(hour * 22.5)),
                end: Date(),
                text: "Test2"
            )
        ],
        // Row 2
        [
            TestItem(
                start: .init(timeIntervalSinceNow: -(hour * 40)),
                end: .init(timeIntervalSinceNow: -(hour * 14)),
                text: "Test3"
            )
        ]
    ]

    private static let hour: TimeInterval = 60 * 60

    static var previews: some View {
        TimelineView(
            viewModel: .init(items: mockData)
        )
    }
}