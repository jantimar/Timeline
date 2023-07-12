import SwiftUI

public struct TimelineView<
    Item: TimelineItem & Identifiable,
    ItemView: View,
    GridView: View
>: View {

    @ObservedObject private var viewModel: TimelineViewModel<Item>

    ///  Create View for specific Item
    @ViewBuilder private let item: (Item) -> ItemView
    /// Initialize grdi view with  minimal, maximal date and width
    @ViewBuilder private let grid: (Date, Date, CGFloat) -> GridView?

    private var rowHeight: CGFloat
    private var rowOffset: CGFloat
    private let trailingIdentifier = "time-line-trailing-id"

    public var body: some View {
        ScrollViewReader { scrollReader in
            GeometryReader { reader in
                ScrollView([.horizontal, .vertical]) {
                    HStack(spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            // Add Grid view
                            grid(viewModel.minimalDate, viewModel.maximalDate, reader.size.width)
                                .zIndex(-0.1)

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
                    .frame(maxWidth: .infinity)
                    .frame(height: CGFloat(viewModel.items.count) * (rowHeight + rowOffset) + 40)
                }
            }
            .onAppear {
                scrollReader.scrollTo(trailingIdentifier, anchor: .trailing)
            }
        }
        // + 40 is grid numbers height
    }

    /// Initialize TimelinView with custome item view
    /// - Parameters:
    ///   - rowHeight: Height of row in timelines if has more as one
    ///   - rowOffset: Offset between rows if timeline has more as one
    ///   - viewModel: View model for timeline
    ///   - item: Custom item view initialized with timeline item protocol
    public init(
        rowHeight: CGFloat = 60,
        rowOffset: CGFloat = 10,
        viewModel: TimelineViewModel<Item>,
        @ViewBuilder item: @escaping (Item) -> ItemView,
        @ViewBuilder grid: @escaping (Date, Date, CGFloat) -> GridView?
    ) {
        self.rowHeight = rowHeight
        self.rowOffset = rowOffset
        self.viewModel = viewModel
        self.item = item
        self.grid = grid
    }
}

// MARK: - Initis
extension TimelineView where ItemView == TimelineItemView, GridView == TimelineGridView {
    public init(
        rowHeight: CGFloat = 60,
        rowOffset: CGFloat = 10,
        viewModel: TimelineViewModel<Item>
    ) {
        self.rowHeight = rowHeight
        self.rowOffset = rowOffset
        self.viewModel = viewModel
        self.item = TimelineItemView.init(item:)
        self.grid = { minimalDate, maximalDate, width in
            TimelineGridView(
                viewModel: .init(
                    scale: viewModel.scale,
                    minimalDate: minimalDate,
                    maximalDate: maximalDate
                ),
                width: width
            )
        }
    }
}

extension TimelineView where GridView == EmptyView {
    public init(
        rowHeight: CGFloat = 60,
        rowOffset: CGFloat = 10,
        viewModel: TimelineViewModel<Item>,
        @ViewBuilder item: @escaping (Item) -> ItemView
    ) {
        self.rowHeight = rowHeight
        self.rowOffset = rowOffset
        self.viewModel = viewModel
        self.item = item
        self.grid = { _, _, _ in nil }
    }
}

// MARK: - Helper views
private extension TimelineView {
    // Vertical rows
    @ViewBuilder
    func rows(width: CGFloat) -> some View {
        LazyVStack(alignment: .leading, spacing: rowOffset) {
            // Iterate rows
            ForEach(Array(viewModel.items.enumerated()), id: \.offset) { row in
                ZStack(alignment: .leading) {
                    columns(items: row.element, width: width)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // Horizontal columns in row
    @ViewBuilder
    func columns(items: [Item], width: CGFloat) -> some View {
        // Iterate items in row
        ForEach(items, id: \.id) { item in
            HStack(spacing: 0) {
                self.item(item)
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

// MARK: - Previews
struct TimelineView_Previews: PreviewProvider {

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
        .tint(.red.opacity(0.9))
    }
}
