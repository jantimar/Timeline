import SwiftUI

public struct TimelineGridView: View {

    @ObservedObject private var viewModel: TimelineGridViewModel
    @State var width: CGFloat

    private let lineWidth: CGFloat = 50

    public var body: some View {
        ForEach(viewModel.chunks, id: \.date) { chunk in
            VStack( alignment: .center) {
                // grid line
                Color.gray
                    .frame(width: 0.5)
                    .frame(maxHeight: .infinity)

                // labels
                Text(chunk.title)
                    .font(.system(size: 10))
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
            }
            .frame(width: lineWidth)
            .offset(x: viewModel.horizontalOffset(for: chunk.date, width: width))
            .offset(x: -(lineWidth / 2))
        }
    }

    public init(viewModel: TimelineGridViewModel, width: CGFloat) {
        self.viewModel = viewModel
        self.width = width
    }
}
