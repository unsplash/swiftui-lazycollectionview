import SwiftUI

/// A view that presents an ordered collection of data items using a customizable layout.
public struct LazyCollectionView<Data, Layout, Content>: View
where Data: RandomAccessCollection & Equatable,
      Data.Index == Int,
      Data.Element: Identifiable,
      Layout: LazyCollectionLayout,
      Content: View {

    /// The identified data that the LazyCollectionView instance uses to create views dynamically.
    public var data: Data

    /// The layout object that calculates the positions of the views.
    @ObservedObject public var layout: Layout

    /// The frame of the instance's parent view.
    public var parentFrame: CGRect?

    /// The view builder that creates views dynamically.
    @ViewBuilder public var content: (Data.Element) -> Content

    /// Creates a LazyCollectionView instance.
    ///
    /// - Parameters:
    ///   - data: The identified data that the LazyCollectionView instance uses to create views dynamically.
    ///   - layout: The layout object that calculates the positions of the views.
    ///   - parentFrame: The frame of the instance's parent view.
    ///   - content: The view builder that creates views dynamically.
    public init(data: Data, layout: Layout, parentFrame: CGRect? = nil, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self._layout = ObservedObject(wrappedValue: layout)
        self.parentFrame = parentFrame
        self.content = content
    }

    public var body: some View {
        let width: CGFloat? = layout.contentSize.width > 0 ? layout.contentSize.width : nil
        let height: CGFloat? = layout.contentSize.height > 0 ? layout.contentSize.height : nil

        GeometryReader { proxy in
            let parentFrame = parentFrame ?? CGRect(origin: .zero, size: proxy.size)
            let localFrame = proxy.frame(in: .local)
            let globalFrame = proxy.frame(in: .global)
            let visibleRect = CGRect(x: -globalFrame.origin.x + localFrame.origin.x + parentFrame.origin.x,
                                     y: -globalFrame.origin.y + localFrame.origin.y + parentFrame.origin.y,
                                     width: parentFrame.maxX,
                                     height: parentFrame.maxY)

            let attributes = layout.layoutAttributesForElements(in: visibleRect)
            ZStack {
                ForEach(attributes) { attributes in
                    if attributes.index < data.count {
                        let element = data[attributes.index]
                        content(element)
                            .frame(width: attributes.frame.size.width, height: attributes.frame.size.height)
                            .position(CGPoint(x: attributes.frame.midX, y: attributes.frame.midY))
                            .id(attributes.id)
                    }
                }
            }
            .onAppear {
                layout.setParentSize(proxy.size)
                layout.prepare(withData: data)
            }
            #if os(visionOS)
            .onChange(of: self.parentFrame) { oldValue, newValue in
                onParentFrameChanged(newValue)
            }
            #else
            .onChange(of: self.parentFrame, perform: onParentFrameChanged(_:))
            #endif
        }
        .frame(width: width, height: height)
        #if os(visionOS)
        .onChange(of: data) { _, newValue in
            onDataChanged(newValue)
        }
        #else
        .onChange(of: data, perform: onDataChanged(_:))
        #endif
    }

    private func onParentFrameChanged(_ newValue: CGRect?) {
        guard let newParentSize = newValue?.size else { return }
        layout.setParentSize(newParentSize)
        layout.prepare(withData: data)
    }

    private func onDataChanged(_ newData: Data) {
        layout.prepare(withData: newData)
    }
}
