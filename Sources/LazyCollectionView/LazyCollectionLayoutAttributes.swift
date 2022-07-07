import SwiftUI

/// A layout object that holds the layout-related attributes for a given item in a lazy collection view.
public struct LazyCollectionLayoutAttributes {

    /// The index of the element in the lazy collection view's data.
    public let index: Int

    /// The frame rectangle of the view representing the element.
    public let frame: CGRect

    /// Creates a layout attributes object.
    ///
    /// - Parameters:
    ///   - index: The index of the element in the lazy collection view's data.
    ///   - frame: The frame rectangle of the view representing the element.
    public init(index: Int, frame: CGRect) {
        self.index = index
        self.frame = frame
    }
}

extension LazyCollectionLayoutAttributes: Identifiable {

    public var id: Int { index }
}
