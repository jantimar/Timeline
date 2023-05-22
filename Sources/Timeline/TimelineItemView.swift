import SwiftUI

struct TimelineItemView: View {

    var item: TimelineItem

    var body: some View {
        ZStack(alignment: .leading) {
            Color.red.opacity(0.3)

            Text(item.text)
                .padding(.horizontal)
        }
        .cornerRadius(4)
    }
}
