import SwiftUI
import LazyCollectionView

protocol ColumnLayoutItem: Identifiable {
    var size: CGSize { get }
}

class ColumnLayout<Item>: ObservableObject, LazyCollectionLayout where Item: ColumnLayoutItem {
    @Published private(set) var contentSize: CGSize = .zero
    private(set) var layoutAttributes = [LazyCollectionLayoutAttributes]()

    private let layoutProperties: ColumnLayoutProperties

    init(properties: ColumnLayoutProperties = AutomaticColumnLayoutProperties.default) {
        layoutProperties = properties
    }

    func setParentSize(_ parentSize: CGSize) {
        contentSize.width = parentSize.width
    }

    func prepare<Data>(withData data: Data) where Data: Equatable, Data: RandomAccessCollection, Data.Element: Identifiable, Data.Index == Int {
        guard let data = data as? [Item] else { return }
        reset()
        generateAttributes(for: data)
    }

    func prepare<Element>(forUpdates updates: CollectionDifference<Element>) where Element: Identifiable {
        guard let updates = updates as? CollectionDifference<Item> else { return }
        var newData = [Item]()
        updates.forEach { change in
            switch change {
                // Only append items
            case .insert(_, let item, _):
                newData.append(item)

                // No support for removing items
            case .remove(_, _, _):
                break
            }
        }
        generateAttributes(for: newData)
    }

    func layoutAttributesForElements(in rect: CGRect) -> [LazyCollectionLayoutAttributes] {
        let insetRect = rect.insetBy(dx: -rect.width, dy: -rect.height)
        var attributes = [LazyCollectionLayoutAttributes]()

        if isAttributes(at: 0, in: insetRect) {
            addAttributes(in: &attributes, from: 0, inRect: insetRect)
        } else if isAttributes(at: layoutAttributes.count-1, in: insetRect) {
            addAttributes(in: &attributes, before: layoutAttributes.count-1, inRect: insetRect)
        } else if let index = firstAttributesIndex(in: insetRect) {
            addAttributes(in: &attributes, before: index, inRect: insetRect)
            addAttributes(in: &attributes, from: index+1, inRect: insetRect)
        }

        return attributes.sorted { $0.index > $1.index }
    }

    // MARK: - Layout calculations

    private var generator: Generator?

    class Generator {

        var contentHeight: CGFloat { (columnHeights.max() ?? 0) + itemSpacing }

        private let numberOfColumns: Int
        private let isSingleColumn: Bool
        private let itemSpacing: CGFloat
        private let margin: CGFloat
        private let columnWidth: CGFloat
        private var columnHeights: [CGFloat]

        init(layoutProcessor: ColumnLayoutProperties, contentWidth: CGFloat) {
            numberOfColumns = layoutProcessor.numberOfColumnsForWidth(contentWidth)
            isSingleColumn = numberOfColumns == 1
            itemSpacing = layoutProcessor.spacingForWidth(contentWidth)
            margin = layoutProcessor.marginForWidth(contentWidth)
            columnWidth = layoutProcessor.columnWidthForWidth(contentWidth)
            columnHeights = [CGFloat](repeating: 0, count: numberOfColumns)
        }

        func generateAttributes(with data: [Item], indexOffset: Int) -> [LazyCollectionLayoutAttributes] {
            var layoutAttributes = [LazyCollectionLayoutAttributes]()
            data.enumerated().forEach { (index, element) in
                let itemSize = element.size
                let columnIndex = indexOfNextColumn()
                guard columnIndex < columnHeights.count else { return }
                let origin = originForColumn(columnIndex)
                let size = self.itemSize(from: itemSize, with: columnWidth)
                columnHeights[columnIndex] = origin.y + size.height + itemSpacing
                let frame = CGRect(origin: origin, size: size)
                let attributes = LazyCollectionLayoutAttributes(index: index + indexOffset, frame: frame)
                layoutAttributes.append(attributes)
            }
            return layoutAttributes
        }

        private func originForColumn(_ column: Int) -> CGPoint {
            guard column < columnHeights.count else { return .zero }
            let x = isSingleColumn ? 0 : margin + CGFloat(column) * (columnWidth + itemSpacing)
            let y = columnHeights[column]
            return CGPoint(x: x, y: y)
        }

        private func indexOfNextColumn() -> Int {
            guard let minHeight = columnHeights.min() else { return 0 }
            return columnHeights.firstIndex(where: { $0 == minHeight }) ?? 0
        }

        private func itemSize(from size: CGSize, with columnWidth: CGFloat) -> CGSize {
            let height = size.height * columnWidth / size.width
            return CGSize(width: floor(columnWidth), height: floor(height))
        }
    }

    private func generateAttributes(for data: [Item]) {
        guard let generator = generator else { return }
        let newLayoutAttributes = generator.generateAttributes(with: data, indexOffset: layoutAttributes.count)
        layoutAttributes.append(contentsOf: newLayoutAttributes)
        contentSize.height = generator.contentHeight
    }

    private func reset() {
        layoutAttributes.removeAll()
        contentSize.height = 0
        generator = Generator(layoutProcessor: layoutProperties, contentWidth: contentSize.width)
    }

    private func addAttributes(in attributes: inout [LazyCollectionLayoutAttributes], from startIndex: Int, inRect rect: CGRect) {
        var lastAttributeMaxY: CGFloat = 0
        for index in startIndex..<layoutAttributes.count {
            let attr = layoutAttributes[index]
            guard attr.frame.intersects(rect) || attr.frame.maxY < lastAttributeMaxY else { break }
            attributes.append(attr)
            lastAttributeMaxY = max(lastAttributeMaxY, attr.frame.maxY)
        }
    }

    private func addAttributes(in attributes: inout [LazyCollectionLayoutAttributes], before endIndex: Int, inRect rect: CGRect) {
        for index in stride(from: endIndex, to: 0, by: -1) {
            let attr = layoutAttributes[index]
            guard attr.frame.intersects(rect) else { break }
            attributes.append(attr)
        }
    }

    private func isAttributes(at index: Int, in rect: CGRect) -> Bool {
        guard index >= 0, index < layoutAttributes.count else { return false }
        let attr = layoutAttributes[index]
        return attr.frame.intersects(rect)
    }

    private func firstAttributesIndex(in rect: CGRect) -> Int? {
        var lowerBound = 0
        var upperBound = layoutAttributes.count
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            let frame = layoutAttributes[midIndex].frame

            let nextIndex = midIndex + 1
            let nextFrame = layoutAttributes[nextIndex].frame

            if frame.intersects(rect) && nextFrame.intersects(rect) {
                return midIndex
            } else if frame.midY < rect.midY {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }

    private func itemSize(from size: CGSize, with columnWidth: CGFloat) -> CGSize {
        let height = size.height * columnWidth / size.width
        return CGSize(width: floor(columnWidth), height: floor(height))
    }

}
