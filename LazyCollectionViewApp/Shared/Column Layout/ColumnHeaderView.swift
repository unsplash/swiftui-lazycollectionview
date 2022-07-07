import SwiftUI

struct ColumnHeaderView: View {
    private let description = """
This layout is used in the **Unsplash for iOS** app to display a list of photos. It is inspired by `UICollectionView`, which the app used before.

An important difference with `UICollectionView` is that the content is not laid out inside a scroll view. This means that `LazyCollectionView` can be easily combined with other views like this header inside a `ScrollView`.

It also lays out the views differently depending of the width of the view.
"""

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "info.circle.fill")
                .font(.title)
                .foregroundColor(.cyan)
                .background(Color.white)
                .mask(Circle().padding(2))

            Text(.init(description))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color.cyan.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ColumnHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnHeaderView()
    }
}
