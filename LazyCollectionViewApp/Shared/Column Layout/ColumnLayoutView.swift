import SwiftUI
import LazyCollectionView

struct ColumnLayoutView: View {
    let sizedNamedColors: [SizedNamedColor]
    @StateObject var layout = ColumnLayout<SizedNamedColor>()

    var body: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                ColumnHeaderView()
                    .padding()

                LazyCollectionView(data: sizedNamedColors,
                                   layout: layout,
                                   parentFrame: geometryProxy.frame(in: .local),
                                   content: { sizedNamedColor in
                    NamedColorView(namedColor: sizedNamedColor.namedColor)
                })
            }
        }
        .navigationTitle("Column Layout")
    }
}

struct ColumnLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnLayoutView(sizedNamedColors: SizedNamedColor.randomSamples(count: 100))
    }
}
