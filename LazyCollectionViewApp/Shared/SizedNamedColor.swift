import SwiftUI

struct SizedNamedColor: ColumnLayoutItem {
    var id: NamedColor.ID { namedColor.id }
    let namedColor: NamedColor
    let size: CGSize
}

extension SizedNamedColor: Equatable {}

extension SizedNamedColor {

    static func randomSamples(count: Int) -> [SizedNamedColor] {
        let aspectRatios: [Double] = [
            1,
            2/3,
            3/2,
            3/4,
            4/3,
            4/3,
            3/4,
            9/16,
            3/4
        ]
        let namedColors = NamedColor.randomSamples(count: count)

        return namedColors.map { namedColor in
            let aspectRatio = aspectRatios.randomElement()!
            let size = CGSize(width: 200, height: 200*aspectRatio)
            return SizedNamedColor(namedColor: namedColor, size: size)
        }
    }
}
