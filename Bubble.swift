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
                .modifier(BubbleFrame(color: .green))
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
    func bubbleFrame(color: Color) -> some View {
        modifier(BubbleFrame(color: color))
    }
}

public struct BubbleFrame: ViewModifier {
    private let color: Color
    
    @State private var size: CGSize = .init(width: 0, height: 0)
    
    public init(color: Color) {
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            BubbleShape(size: size)
                .stroke(color)
                .frame(width: size.width, height: size.height, alignment: .center)
            content
                .readSize(onChange: { value in size = value })
        }
    }
    
    private struct BubbleShape: Shape {
        private let customSize: CGSize 
        
        init(size: CGSize) {
            self.customSize = size
        }
        
        func path(in rect: CGRect) -> Path {
            let centerX = customSize.width / 2
            let arrowSize: CGFloat = 10
            
            var customShape = Path { p in
                p.move(to: CGPoint(x: 0, y: 0))
                p.addLines([
                    .init(x: 0, y: 0),
                    .init(x: centerX - arrowSize, y: 0),
                    .init(x: centerX, y: -arrowSize),
                    .init(x: centerX + arrowSize, y: 0),
                    .init(x: customSize.width, y: 0),
                    .init(x: customSize.width, y: customSize.height),
                    .init(x: 0, y: customSize.height),
                    .init(x: 0, y: 0)
                ])
            }
            return customShape
        }
    }
}
