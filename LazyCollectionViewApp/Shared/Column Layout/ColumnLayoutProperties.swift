import SwiftUI

protocol ColumnLayoutProperties {
    var spacing: CGFloat { get }
    var cellContentMargin: CGFloat { get }

    func spacingForWidth(_ width: CGFloat) -> CGFloat
    func marginForWidth(_ width: CGFloat) -> CGFloat
    func numberOfColumnsForWidth(_ width: CGFloat) -> Int
    func columnWidthForWidth(_ width: CGFloat) -> CGFloat
}

struct AutomaticColumnLayoutProperties: ColumnLayoutProperties {

    let minimumColumnWidth: CGFloat
    let spacing: CGFloat
    let cellContentMargin: CGFloat

    static var `default`: AutomaticColumnLayoutProperties {
        AutomaticColumnLayoutProperties(minimumColumnWidth: 260, spacing: 16, cellContentMargin: 16)
    }

    func spacingForWidth(_ width: CGFloat) -> CGFloat {
        numberOfColumnsForWidth(width) == 1 ? 1 : spacing
    }

    func marginForWidth(_ width: CGFloat) -> CGFloat {
        numberOfColumnsForWidth(width) == 1 ? 0 : spacing
    }

    func numberOfColumnsForWidth(_ width: CGFloat) -> Int {
        let numberOfColumns = Int(floor(width - spacing) / (minimumColumnWidth + spacing))
        return min(numberOfColumns, 3)
    }

    func columnWidthForWidth(_ width: CGFloat) -> CGFloat {
        let numberOfColumns = numberOfColumnsForWidth(width)
        return numberOfColumns == 1 ? width : max(0, (width - (CGFloat(numberOfColumns + 1) * spacing)) / CGFloat(numberOfColumns))
    }

}

// MARK: - Fixed columns

struct FixedColumnLayoutProperties: ColumnLayoutProperties {

    let numberOfColumns: Int
    let spacing: CGFloat
    let margin: CGFloat
    let cellContentMargin: CGFloat

    static var twoColumns: FixedColumnLayoutProperties {
        FixedColumnLayoutProperties(numberOfColumns: 2, spacing: 2, margin: 0, cellContentMargin: 4)
    }

    func spacingForWidth(_ width: CGFloat) -> CGFloat {
        spacing
    }

    func marginForWidth(_ width: CGFloat) -> CGFloat {
        margin
    }

    func numberOfColumnsForWidth(_ width: CGFloat) -> Int {
        numberOfColumns
    }

    func columnWidthForWidth(_ width: CGFloat) -> CGFloat {
        max(0, round((width - (CGFloat(numberOfColumns - 1) * spacing) - margin * 2) / CGFloat(numberOfColumns)))
    }

}
