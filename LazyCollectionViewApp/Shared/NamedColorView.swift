import SwiftUI

struct NamedColorView: View {
    var namedColor: NamedColor
    var body: some View {
        ZStack(alignment: .topLeading) {
            namedColor.color
                .mask(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading) {
                Text(namedColor.name)
                    .font(.headline)

                Text("ID: " + String(namedColor.id))
                    .font(.subheadline)
                    .opacity(0.6)
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

struct NameColorView_Previews: PreviewProvider {
    static var previews: some View {
        NamedColorView(namedColor: NamedColor(id: 0, name: "Blue", color: .blue))
    }
}
