import SwiftUI

/// A type that applies a custom appearance to inline link markdown elements
public protocol InlineLinkMarkdownStyle {
    /// The properties of an inline link markdown element
    typealias Configuration = InlineLinkMarkdownConfiguration
    /// Creates a view that represents the body of a label
    func makeBody(configuration: Configuration) -> Text
}

/// The properties of an inline link markdown element
public struct InlineLinkMarkdownConfiguration {
	public init(content: String, destination: String?) {
		self.content = content
		self.destination = destination
	}
	
    /// The textual content for this element
    public let content: String
	/// The destination for this element
	public let destination: String?
    /// Returns a default inline link markdown representation
    public var label: Text { Text(verbatim: content) }
}

/// An inline link style that sets the `foregroundColor` to the view's current `accentColor`
public struct DefaultInlineLinkMarkdownStyle: InlineLinkMarkdownStyle {
	let interactive: Bool
	
	public init(interactive: Bool) {
		self.interactive = interactive
	}
	
    public func makeBody(configuration: Configuration) -> Text {
		if #available(macOS 12, *), interactive, let destination = configuration.destination {
			return Text(try! AttributedString(markdown: "[\(configuration.content)](\(destination))"))
		} else {
			return configuration.label
				.foregroundColor(Color(NSColor.linkColor))
		}
    }
}

public extension InlineLinkMarkdownStyle where Self == DefaultInlineLinkMarkdownStyle {
    /// An inline link style that sets the `foregroundColor` to the system link color
    ///
	/// - note: **Non-interactive** inline links.
	static var interactiveInline: Self { .init(interactive: true) }
	///
    /// - note: **Non-interactive** inline links.
    static var nonInteractiveInline: Self { .init(interactive: false) }
}

private struct InlineLinkMarkdownEnvironmentKey: EnvironmentKey {
    static let defaultValue: InlineLinkMarkdownStyle = DefaultInlineLinkMarkdownStyle.interactiveInline
}

public extension EnvironmentValues {
    /// The current inline link markdown style
    var markdownInlineLinkStyle: InlineLinkMarkdownStyle {
        get { self[InlineLinkMarkdownEnvironmentKey.self] }
        set { self[InlineLinkMarkdownEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Sets the style for inline link markdown elements
    func markdownInlineLinkStyle<S>(_ style: S) -> some View where S: InlineLinkMarkdownStyle {
        environment(\.markdownInlineLinkStyle, style)
    }
}
