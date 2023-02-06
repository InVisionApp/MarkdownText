import SwiftUI

extension Array where Element == MarkdownInlineElement {
	var hasOnlyLinks: Bool {
		return allSatisfy { $0.attributes.contains(.link) || $0.content.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 }
	}
}

struct InlineMarkdownConfiguration {
    struct Label: View {
		@Environment(\.multilineTextAlignment) private var alignment
		private var stackAlignment: HorizontalAlignment {
			alignment == .leading
			? .leading
			: alignment == .trailing
			? .trailing
			: .center
		}
		
        @Environment(\.font) private var font
        @Environment(\.markdownStrongStyle) private var strong
        @Environment(\.markdownEmphasisStyle) private var emphasis
        @Environment(\.markdownStrikethroughStyle) private var strikethrough
        @Environment(\.markdownInlineCodeStyle) private var code
        @Environment(\.markdownInlineLinkStyle) private var link

        let elements: [MarkdownInlineElement]

        @ViewBuilder var body: some View {
			if elements.hasOnlyLinks {
				VStack(alignment: stackAlignment) {
					ForEach(elements) { element in
						if let destination = element.destination, let url = URL(string: destination) {
							Link(element.content, destination: url).onHover { inside in
								if inside {
									NSCursor.pointingHand.push()
								} else {
									NSCursor.pop()
								}
							}
						}
					}
				}
			} else {
				var hasLinks = false
				
				let rv = elements.reduce(into: Text("")) { result, component in
					if component.attributes.contains(.code) {
						return result = result + code.makeBody(
							configuration: .init(code: component.content, font: font)
						)
					} else if component.attributes.contains(.link) {
						hasLinks = true
						return result = result + link.makeBody(
							configuration: .init(content: component.content, destination: component.destination))
					} else if(component.content == "\n") {
						return result = result + Text(component.content)
					} else {
						return result = result + Text(component.content).apply(
							strong: strong,
							emphasis: emphasis,
							strikethrough: strikethrough,
							attributes: component.attributes
						)
					}
				}
				
				if hasLinks == false {
					rv
				} else {
					rv.onHover { inside in
						if inside {
							NSCursor.pointingHand.push()
						} else {
							NSCursor.pop()
						}
					}
				}
			}
        }
    }

    public let elements: [MarkdownInlineElement]

    public var label: some View {
        Label(elements: elements)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct InlineMarkdownStyle {
    func makeBody(configuration: InlineMarkdownConfiguration) -> some View {
        configuration.label
    }
}
