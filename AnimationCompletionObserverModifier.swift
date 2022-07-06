import SwiftUI

// public struct CustomView: View, Animatable {
//     public init() {}
    
//     @State private var offsetVelocity: CGFloat = 100
//     @State private var offset: CGFloat = 0
//     @State private var rotationDegrees: CGFloat = 0
//     @State private var scale: CGFloat = 1 {
//         didSet {
//             print(scale)
//         }
//     }
    
//     public var body: some View {
//         HStack {
//             Spacer()
//             Text("Text")
//                 .lineLimit(1)
//                 .padding(.all, 10)
//                 .frame(width: 200, height: 100)
//                 .background(Color.yellow)
//                 .border(.blue)
//                 .rotationEffect(.degrees(rotationDegrees))
//                 .offset(x: offset, y: 10)
//                 .scaleEffect(scale)
//             Spacer()
//         }
//         .frame(width: 600, height: 300)
//         .border(.red)
//         .clipped()
//         .onTapGesture {
//             withAnimation(.linear(duration: 0.5)) {
//                 scale += 1
//                 rotationDegrees += 90
//                 offsetVelocity *= -1
//                 offset += offsetVelocity
//             }
//         }
//         .onAnimationCompleted(for: scale, completion: {
//             print("finished")
//         })
//     }
// }

public extension View {
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> some View {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}

public struct AnimationCompletionObserverModifier<Value: VectorArithmetic>: GeometryEffect {
    public var animatableData: Value {
        didSet { notifyCompletionIfFinished() }
    }
    
    private var targetValue: Value
    private var completion: () -> Void
    
    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }
    
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }
        DispatchQueue.main.async {
            self.completion()
        }
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform()
    }
}

