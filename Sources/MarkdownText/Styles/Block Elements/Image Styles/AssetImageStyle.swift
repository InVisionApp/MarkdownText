import SwiftUI

/// An image style that renders an SFSymbol (if possible)
public struct AssetImageMarkdownStyle: ImageMarkdownStyle {
	let bundle: Bundle?
	
	public init(bundle: Bundle?) {
		self.bundle = bundle
	}
	
	public func makeBody(configuration: Configuration) -> some View {
		if let source = configuration.source {
			Image(source, bundle: bundle).resizable().scaledToFit().padding([.leading, .trailing], -20)
		}
	}
}
