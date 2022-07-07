import SwiftUI

struct ReadMeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                Text("👋 Hi! Thanks for trying this!")
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 16) {
                    Text("The goal of this component is to bring the flexibility of UIKit's `UICollectionView` to SwiftUI, especially for custom layouts. It needs to be easily embeddable in a `ScrollView` and support lazy loading its content like `LazyVStack`.\n\nIt is best suited when used in a `ScrollView` and contains many items that would benefit from lazy loading. Otherwise, the Layout API introduced in iOS 16 and macOS 13 is a better option.\n\nImprovements and more sample layouts are welcome!")
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(alignment: .top) {
                        Text("⚠️")
                            .font(.title)
                        Text("The list and grid layouts in this project and just examples and should not be used in a project. You should use `LazyVStack` and `LazyVGrid` respectively.")
                            .font(.callout)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(12)
                }

                Text("Components")
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 8) {
                    Text("LazyCollectionView")
                        .font(.title3)
                        .fontWeight(.medium)

                    Text("A view that presents an ordered collection of data items using a customizable layout.")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("LazyCollectionLayout")
                        .font(.title3)
                        .fontWeight(.medium)

                    Text("A type that calculates how the items in a lazy collection view are laid out.")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("LazyCollectionLayoutAttributes")
                        .font(.title3)
                        .fontWeight(.medium)

                    Text("A layout object that holds the layout-related attributes for a given item in a lazy collection view. It is generated by an instance of `LazyCollectionViewLayout` and used by `LazyCollectionView` to lay out its content.")
                }
            }
            .frame(maxWidth: 640)
            .padding()
        }
        .navigationTitle("Read Me")
    }
}

struct ReadMeView_Previews: PreviewProvider {
    static var previews: some View {
        ReadMeView()
    }
}
