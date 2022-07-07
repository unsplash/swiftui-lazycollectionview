import SwiftUI

struct NamedColor: Identifiable {
    var id: Int
    let name: String
    let color: Color
}

extension NamedColor: Equatable {}

extension NamedColor {

    static func randomSamples(count: Int) -> [NamedColor] {
        let samples: [(name: String, color: Color)] = [
            (name: "Blue", color: .blue),
            (name: "Brown", color: .brown),
            (name: "Cyan", color: .cyan),
            (name: "Gray", color: .gray),
            (name: "Green", color: .green),
            (name: "Indigo", color: .indigo),
            (name: "Mint", color: .mint),
            (name: "Orange", color: .orange),
            (name: "Pink", color: .pink),
            (name: "Purple", color: .purple),
            (name: "Red", color: .red),
            (name: "Teal", color: .teal),
            (name: "Yellow", color: .yellow)
        ]

        var namedColors: [NamedColor] = []
        for index in 0..<count {
            guard let sample = samples.randomElement() else { continue }
            let namedColor = NamedColor(id: index, name: sample.name, color: sample.color)
            namedColors.append(namedColor)
        }
        return namedColors
    }
}
