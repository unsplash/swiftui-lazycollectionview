/// ⚠️ Do not use this layout, it is intended for demonstration purpose. Use `LazyVStack` instead.

import SwiftUI
import LazyCollectionView

class ListLayout: LazyCollectionLayout, ObservableObject {
    var spacing: CGFloat = 16
    var padding: CGFloat = 16
    var rowHeight: CGFloat = 88

    @Published var contentSize: CGSize = .zero

    private var layoutAttributes = [LazyCollectionLayoutAttributes]()

    func setParentSize(_ parentSize: CGSize) {
        contentSize.width = parentSize.width
    }

    func prepare<Data>(withData data: Data) where Data : Equatable, Data : RandomAccessCollection, Data.Element : Identifiable, Data.Index == Int {
        reset()
        generateAttributes(for: data)
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

    func generateAttributes<Data>(for data: Data) where Data : Equatable, Data : RandomAccessCollection, Data.Element : Identifiable, Data.Index == Int {
        let indexOffset = layoutAttributes.count
        let contentWidth = contentSize.width - padding * 2
        var currentHeight = contentSize.height
        data.enumerated().forEach { (index, element) in
            let frame = CGRect(x: padding,
                               y: currentHeight,
                               width: contentWidth,
                               height: rowHeight).integral

            layoutAttributes.append(LazyCollectionLayoutAttributes(index: index + indexOffset, frame: frame))

            currentHeight += rowHeight + spacing
        }
        currentHeight -= spacing
        contentSize.height = currentHeight
    }

    private func reset() {
        layoutAttributes.removeAll()
        contentSize.height = padding
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
            if frame.intersects(rect) {
                return midIndex
            } else if frame.midY < rect.midY {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }
}
