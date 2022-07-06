import SwiftUI

public extension View {
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}

public struct AnimationCompletionObserverModifier<Value>: GeometryEffect where Value: VectorArithmetic {
    public typealias AnimatableData = Value
    
    public var animatableData: Self.AnimatableData {
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