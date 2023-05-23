import SwiftUI

public struct TimelineItemView: View {

    public var item: TimelineItem

    public var body: some View {
        ZStack(alignment: .leading) {
            Color.red.opacity(0.3)

            Text(item.text)
                .padding(.horizontal)
        }
        .cornerRadius(4)
    }
}

struct TimelineItemView_Previews: PreviewProvider {

    static var previews: some View {
        TimelineItemView(
            item: TestItem(
                text: "Test Item"
            )
        )
    }
}
