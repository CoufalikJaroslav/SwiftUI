import SwiftUI

public struct Bubble: View {
    public init() {
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 8) {
                    LeftBubble(text: "asdfasdfasf?", padding: .right)
                    LeftBubble(text: "sfsdfasdf.", padding: .right)
                    LeftBubble(text: "asdfasdf", padding: .left)
                    LeftBubble(text: "asdfsd sf asf sadfasf asdfads sdfsdf sdf sadf asdfsdf sdfasdf sdf asdf asdf asdfa sdf sdf asdf", padding: .left)
                    LeftBubble(text: "dsafasd fsadfasdf as fsfsdf sdf asdf asdf asdf asdf asdf safsdf asdfa sdf asdf asd f", padding: .center)
                }
                .padding()
            }
        }
    }
    
    private func LeftBubble(text: String, padding: TextPadding) -> some View {
        HStack {
            if (padding == .right || padding == .center) { Spacer() }
            Text(text)
                .font(.largeTitle)
                .padding()
                .fixedSize(horizontal: false, vertical: true)
                .modifier(BubbleFrame(borderColor: .gray))
            if (padding == .left || padding == .center) { Spacer() }
        }
    }
}

public enum TextPadding {
    case left
    case right
    case center
}

extension View {
    func bubbleFrame(
        backgroundColor: Color = .clear, 
        borderColor: Color = .clear, 
        borderWidth: CGFloat = 1
    ) -> some View {
        modifier(BubbleFrame(
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth
        ))
    }
}

public struct BubbleFrame: ViewModifier {
    private let backgroundColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat
    
    public init(
        backgroundColor: Color = .clear, 
        borderColor: Color = .clear, 
        borderWidth: CGFloat = 1
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                BubbleShape()
                    .fill(backgroundColor)
                    .overlay(
                        BubbleShape()
                            .stroke(
                                borderColor, 
                                style: .init(lineWidth: borderWidth, lineCap: .round)
                            )
                    )
            )
    }
    
    private struct BubbleShape: Shape {
        func path(in rect: CGRect) -> Path {
            let csize = rect.size
            let centerX = csize.width / 2
            let arrowSize: CGFloat = 10
            
            let customShape = Path { p in
                p.move(to: CGPoint(x: 0, y: 0))
                p.addLines([
                    .init(x: 0, y: 0),
                    .init(x: centerX - arrowSize, y: 0),
                    .init(x: centerX, y: -arrowSize),
                    .init(x: centerX + arrowSize, y: 0),
                    .init(x: csize.width, y: 0),
                    .init(x: csize.width, y: csize.height),
                    .init(x: 0, y: csize.height),
                    .init(x: 0, y: 0)
                ])
            }
            return customShape
        }
    }
}
