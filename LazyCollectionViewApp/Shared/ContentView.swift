import SwiftUI

struct ContentView: View {
    @State private var itemCount = 10

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink("Read Me") {
                        ReadMeView()
                    }
                }

                Section("Layouts") {
                    NavigationLink("List layout") {
                        ListLayoutView(namedColors: NamedColor.randomSamples(count: itemCount))
                    }
                    NavigationLink("Grid layout") {
                        GridLayoutView(namedColors: NamedColor.randomSamples(count: itemCount))
                    }
                    NavigationLink("Column layout") {
                        ColumnLayoutView(sizedNamedColors: SizedNamedColor.randomSamples(count: itemCount))
                    }
                }

                Section("Settings") {
                    ItemCountStepper(value: $itemCount)
                }
            }
            .navigationTitle("Demo")

            ReadMeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
