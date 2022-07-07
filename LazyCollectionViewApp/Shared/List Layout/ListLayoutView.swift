import SwiftUI
import LazyCollectionView

struct ListLayoutView: View {
    let namedColors: [NamedColor]
    @StateObject var layout = ListLayout()

    var body: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                HStack {
                    WarningView(message: "This layout is intended as an example and should not be used in an app.\nYou should use `LazyVStack` instead.")
                    Spacer()
                }
                .padding()

                LazyCollectionView(data: namedColors,
                                   layout: layout,
                                   parentFrame: geometryProxy.frame(in: .local),
                                   content: { namedColor in
                    NamedColorView(namedColor: namedColor)
                })
            }
        }
        .navigationTitle("List Layout")
    }
}

struct ListLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        ListLayoutView(namedColors: NamedColor.randomSamples(count: 100))
    }
}
