import SwiftUI

/// A type that calculates how the items in a lazy collection view are laid out.
public protocol LazyCollectionLayout: ObservableObject {

    /// The width and height of the lazy collection view’s contents.
    var contentSize: CGSize { get }

    /// Sets the width and height of the lazy collection view’s parent view.
    func setParentSize(_ parentSize: CGSize)

    /// Tells the layout to update the current layout.
    ///
    /// - Parameters:
    ///   - data: The lazy collection view's data. It can be used to generate the layout attributes.
    func prepare<Data>(withData data: Data) where Data: RandomAccessCollection & Equatable,
                                                  Data.Index == Int,
                                                  Data.Element: Identifiable

    /// Retrieves the layout attributes for all of the views in the specified rectangle.
    ///
    ///  - Returns: An array of `LazyCollectionLayoutAttributes` objects
    ///  representing the layout information for the views.
    func layoutAttributesForElements(in rect: CGRect) -> [LazyCollectionLayoutAttributes]
}
