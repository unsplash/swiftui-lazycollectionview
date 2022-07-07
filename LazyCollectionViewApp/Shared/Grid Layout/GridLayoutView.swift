import SwiftUI
import LazyCollectionView

struct GridLayoutView: View {
    let namedColors: [NamedColor]
    @StateObject var layout = GridLayout()

    var body: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                HStack {
                    WarningView(message: "This layout is intended as an example and should not be used in an app.\nYou should use `LazyVGrid` instead.")
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
        .navigationTitle("Grid Layout")
    }
}

struct GridLayoutView_Previews: PreviewProvider {
    
    static var previews: some View {
        GridLayoutView(namedColors: NamedColor.randomSamples(count: 100))
    }
}
