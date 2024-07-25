//
//  Shimmer.swift
//  Shimmering
//
//  Created by Yi-Hsiu Lee on 2024/7/25.
//

//
//  Shimmer.swift
//  Shimmering
//
//  Created by Yi-Hsiu Lee on 2024/7/25.
//

import SwiftUI

// Reference: https://stackoverflow.com/a/77296012/5311192

/// A view modifier that adds a shimmering effect to any view.
///
/// This modifier creates an animated gradient mask that moves across the view,
/// creating a shimmering effect often used to indicate a loading state.
public struct Shimmer: ViewModifier {
    /// The animation to be applied to the shimmering effect.
    private let animation: Animation
    /// The gradient used to create the shimmering effect.
    private let gradient: Gradient
    /// The minimum point of the gradient's range.
    private let min: CGFloat
    /// The maximum point of the gradient's range.
    private let max: CGFloat
    /// A state variable to track the initial state of the animation.
    @State private var isInitialState = true
    /// The current layout direction of the environment.
    @Environment(\.layoutDirection) private var layoutDirection
    
    /// Initializes the Shimmer modifier with customizable parameters.
    /// - Parameters:
    ///   - animation: A custom animation. Defaults to ``Shimmer/defaultAnimation``.
    ///   - gradient: A custom gradient. Defaults to ``Shimmer/defaultGradient``.
    ///   - bandSize: The size of the animated mask's "band". Defaults to 0.3 unit points, which corresponds to
    ///     30% of the extent of the gradient.
    public init(
        animation: Animation = Self.defaultAnimation,
        gradient: Gradient = Self.defaultGradient,
        bandSize: CGFloat = 0.3
    ) {
        self.animation = animation
        self.gradient = gradient
        // Calculate unit point dimensions beyond the gradient's edges by the band size
        self.min = 0 - bandSize
        self.max = 1 + bandSize
    }
    
    /// The default animation effect.
    public static let defaultAnimation = Animation.linear(duration: 1.5).delay(0.25).repeatForever(autoreverses: false)
    
    /// A default gradient for the animated mask.
    public static let defaultGradient = Gradient(colors: [
        .black.opacity(0.3), // translucent
        .black, // opaque
        .black.opacity(0.3) // translucent
    ])
    
    /*
       Calculating the gradient's animated start and end unit points:
       min,min
          \
           ┌───────┐         ┌───────┐
           │0,0    │ Animate │       │  "forward" gradient
       LTR │       │ ───────►│    1,1│  / // /
           └───────┘         └───────┘
                                      \
                                    max,max
                  max,min
                    /
           ┌───────┐         ┌───────┐
           │    1,0│ Animate │       │  "backward" gradient
       RTL │       │ ───────►│0,1    │  \ \\ \
           └───────┘         └───────┘
                            /
                         min,max
    */
    
    /// The start unit point of our gradient, adjusting for layout direction.
    var startPoint: UnitPoint {
        if layoutDirection == .rightToLeft {
            return isInitialState ? UnitPoint(x: max, y: min) : UnitPoint(x: 0, y: 1)
        } else {
            return isInitialState ? UnitPoint(x: min, y: min) : UnitPoint(x: 1, y: 1)
        }
    }
    
    /// The end unit point of our gradient, adjusting for layout direction.
    var endPoint: UnitPoint {
        if layoutDirection == .rightToLeft {
            return isInitialState ? UnitPoint(x: 1, y: 0) : UnitPoint(x: min, y: max)
        } else {
            return isInitialState ? UnitPoint(x: 0, y: 0) : UnitPoint(x: max, y: max)
        }
    }
    
    /// Applies the shimmering effect to the content.
    /// - Parameter content: The content to which the shimmering effect will be applied.
    /// - Returns: A view with the shimmering effect applied.
    public func body(content: Content) -> some View {
        content
            .mask(LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
            .animation(animation, value: isInitialState)
            .onAppear {
                isInitialState = false
            }
    }
}

public extension View {
    /// Adds an animated shimmering effect to any view, typically to show that an operation is in progress.
    /// - Parameters:
    ///   - active: Convenience parameter to conditionally enable the effect. Defaults to `true`.
    ///   - animation: A custom animation. Defaults to ``Shimmer/defaultAnimation``.
    ///   - gradient: A custom gradient. Defaults to ``Shimmer/defaultGradient``.
    ///   - bandSize: The size of the animated mask's "band". Defaults to 0.3 unit points, which corresponds to
    ///     20% of the extent of the gradient.
    /// - Returns: A view with the shimmering effect applied if `active` is true, otherwise returns the original view.
    @ViewBuilder func shimmering(
        active: Bool = true,
        animation: Animation = Shimmer.defaultAnimation,
        gradient: Gradient = Shimmer.defaultGradient,
        bandSize: CGFloat = 0.3
    ) -> some View {
        if active {
            modifier(Shimmer(animation: animation, gradient: gradient, bandSize: bandSize))
        } else {
            self
        }
    }
    
    /// Adds an animated shimmering effect to any view, typically to show that an operation is in progress.
    /// - Parameters:
    ///   - active: Convenience parameter to conditionally enable the effect. Defaults to `true`.
    ///   - duration: The duration of a shimmer cycle in seconds.
    ///   - bounce: Whether to bounce (reverse) the animation back and forth. Defaults to `false`.
    ///   - delay: A delay in seconds. Defaults to `0.25`.
    /// - Returns: A view with the shimmering effect applied if `active` is true, otherwise returns the original view.
    @available(*, deprecated, message: "Use shimmering(active:animation:gradient:bandSize:) instead.")
    @ViewBuilder func shimmering(
        active: Bool = true, duration: Double, bounce: Bool = false, delay: Double = 0.25
    ) -> some View {
        shimmering(
            active: active,
            animation: .linear(duration: duration).delay(delay).repeatForever(autoreverses: bounce)
        )
    }
}
