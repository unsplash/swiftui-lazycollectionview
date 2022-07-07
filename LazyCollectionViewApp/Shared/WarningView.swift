import SwiftUI

struct WarningView: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("⚠️")
                .font(.title)

            Text(.init(message))
                .fontWeight(.medium)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(12)
    }
}

struct WarningView_Previews: PreviewProvider {
    static var previews: some View {
        WarningView(message: "This is a warning, be careful!")
    }
}
