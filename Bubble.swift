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
        let radius: CGFloat = 16
        
        content
            .background(
                BubbleShape(radius: radius)
                    .fill(backgroundColor)
                    .overlay(
                        BubbleShape(radius: radius)
                            .stroke(
                                borderColor, 
                                style: .init(lineWidth: borderWidth, lineCap: .round)
                            )
                    )
            )
    }
    
    private struct BubbleShape: Shape {
        let radius: CGFloat
        
        init(radius: CGFloat = 20) {
            self.radius = radius
        }
        
        func path(in rect: CGRect) -> Path {
            let centerX = rect.size.width / 2
            let arrowSize: CGFloat = 10
            
            let customShape = Path { p in
                p.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
                
                p.addLine(to: .init(x: centerX - arrowSize, y: rect.minY))
                p.addLine(to: .init(x: centerX, y: -arrowSize))
                p.addLine(to: .init(x: centerX + arrowSize, y: rect.minY))
                
                p.addLine(to: .init(x: rect.maxX - radius, y: rect.minY))
                
                p.addRelativeArc(
                    center: .init(x: rect.maxX - radius, y: rect.minY + radius), 
                    radius: radius,
                    startAngle: Angle.degrees(3*90), 
                    delta: Angle.degrees(90)
                )
                
                p.addLine(to: .init(x: rect.maxX, y: rect.maxY - radius))
                
                p.addRelativeArc(
                    center: .init(x: rect.maxX - radius, y: rect.maxY - radius), 
                    radius: radius,
                    startAngle: Angle.degrees(0*90), 
                    delta: Angle.degrees(90)
                )
                
                p.addLine(to: .init(x: rect.minX + radius, y: rect.maxY))
                
                p.addRelativeArc(
                    center: .init(x: rect.minX + radius, y: rect.maxY - radius), 
                    radius: radius,
                    startAngle: Angle.degrees(1*90), 
                    delta: Angle.degrees(90)
                )
                
                p.addLine(to: .init(x: rect.minX, y: rect.minY + radius))
                
                p.addRelativeArc(
                    center: .init(x: rect.minX + radius, y: rect.minY + radius), 
                    radius: radius,
                    startAngle: Angle.degrees(2*90), 
                    delta: Angle.degrees(90)
                )
            }
            return customShape
        }
    }
}
