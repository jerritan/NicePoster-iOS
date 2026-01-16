import SwiftUI
import Combine

// MARK: - Add to Cart Animation Overlay
struct AddToCartAnimationView: View {
    let image: GeneratedImage
    let startPosition: CGPoint
    let endPosition: CGPoint
    let onComplete: () -> Void
    
    @State private var animationProgress: CGFloat = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var showTrail = true
    
    var body: some View {
        ZStack {
            // Glow Trail
            if showTrail {
                TrailPath(
                    start: startPosition,
                    end: endPosition,
                    progress: animationProgress
                )
                .stroke(
                    LinearGradient(
                        colors: [
                            NPColors.brandPrimary.opacity(0.6),
                            NPColors.brandPrimary.opacity(0.2),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .blur(radius: 2)
            }
            
            // Flying Bubble
            ZStack {
                // Glow background
                Circle()
                    .fill(NPColors.brandPrimary.opacity(0.3))
                    .frame(width: 70, height: 70)
                    .blur(radius: 10)
                
                // Image bubble
                RoundedRectangle(cornerRadius: 16)
                    .fill(image.mockColor)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: image.mockIcon)
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.6))
                    )
                    .shadow(color: NPColors.brandPrimary.opacity(0.5), radius: 12, x: 0, y: 4)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .position(currentPosition)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private var currentPosition: CGPoint {
        let path = UIBezierPath()
        path.move(to: startPosition)
        
        // Create a curved path
        let controlPoint1 = CGPoint(
            x: startPosition.x + (endPosition.x - startPosition.x) * 0.3,
            y: startPosition.y - 100
        )
        let controlPoint2 = CGPoint(
            x: startPosition.x + (endPosition.x - startPosition.x) * 0.7,
            y: endPosition.y - 150
        )
        path.addCurve(to: endPosition, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        // Get point at current progress
        let point = path.point(at: animationProgress)
        return point ?? endPosition
    }
    
    private func startAnimation() {
        // Scale down and fly
        withAnimation(.easeIn(duration: 0.1)) {
            scale = 0.6
        }
        
        withAnimation(.easeInOut(duration: 0.6)) {
            animationProgress = 1.0
        }
        
        // Final pop and fade
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                scale = 0.3
            }
            withAnimation(.easeOut(duration: 0.15)) {
                opacity = 0
            }
        }
        
        // Complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            onComplete()
        }
    }
}

// MARK: - Trail Path
struct TrailPath: Shape {
    let start: CGPoint
    let end: CGPoint
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        
        let controlPoint1 = CGPoint(
            x: start.x + (end.x - start.x) * 0.3,
            y: start.y - 100
        )
        let controlPoint2 = CGPoint(
            x: start.x + (end.x - start.x) * 0.7,
            y: end.y - 150
        )
        
        path.addCurve(to: end, control1: controlPoint1, control2: controlPoint2)
        
        return path.trimmedPath(from: max(0, progress - 0.3), to: progress)
    }
}

// MARK: - UIBezierPath Extension
extension UIBezierPath {
    func point(at progress: CGFloat) -> CGPoint? {
        var point: CGPoint = .zero
        let pathLength = self.length
        let targetLength = pathLength * progress
        
        var currentLength: CGFloat = 0
        var previousPoint = self.currentPoint
        
        self.cgPath.applyWithBlock { element in
            switch element.pointee.type {
            case .moveToPoint:
                previousPoint = element.pointee.points[0]
            case .addLineToPoint:
                let nextPoint = element.pointee.points[0]
                let segmentLength = hypot(nextPoint.x - previousPoint.x, nextPoint.y - previousPoint.y)
                if currentLength + segmentLength >= targetLength {
                    let ratio = (targetLength - currentLength) / segmentLength
                    point = CGPoint(
                        x: previousPoint.x + (nextPoint.x - previousPoint.x) * ratio,
                        y: previousPoint.y + (nextPoint.y - previousPoint.y) * ratio
                    )
                }
                currentLength += segmentLength
                previousPoint = nextPoint
            case .addCurveToPoint:
                let control1 = element.pointee.points[0]
                let control2 = element.pointee.points[1]
                let endPoint = element.pointee.points[2]
                
                // Approximate curve with line segments
                let steps = 20
                for i in 1...steps {
                    let t = CGFloat(i) / CGFloat(steps)
                    let nextPoint = bezierPoint(t: t, p0: previousPoint, p1: control1, p2: control2, p3: endPoint)
                    let stepPrev = bezierPoint(t: CGFloat(i-1) / CGFloat(steps), p0: previousPoint, p1: control1, p2: control2, p3: endPoint)
                    let segmentLength = hypot(nextPoint.x - stepPrev.x, nextPoint.y - stepPrev.y)
                    
                    if currentLength + segmentLength >= targetLength {
                        let ratio = (targetLength - currentLength) / segmentLength
                        point = CGPoint(
                            x: stepPrev.x + (nextPoint.x - stepPrev.x) * ratio,
                            y: stepPrev.y + (nextPoint.y - stepPrev.y) * ratio
                        )
                        return
                    }
                    currentLength += segmentLength
                }
                previousPoint = endPoint
            default:
                break
            }
        }
        
        return point == .zero ? nil : point
    }
    
    private var length: CGFloat {
        var totalLength: CGFloat = 0
        var previousPoint = self.currentPoint
        
        self.cgPath.applyWithBlock { element in
            switch element.pointee.type {
            case .moveToPoint:
                previousPoint = element.pointee.points[0]
            case .addLineToPoint:
                let nextPoint = element.pointee.points[0]
                totalLength += hypot(nextPoint.x - previousPoint.x, nextPoint.y - previousPoint.y)
                previousPoint = nextPoint
            case .addCurveToPoint:
                let control1 = element.pointee.points[0]
                let control2 = element.pointee.points[1]
                let endPoint = element.pointee.points[2]
                
                let steps = 20
                for i in 1...steps {
                    let t = CGFloat(i) / CGFloat(steps)
                    let nextPoint = bezierPoint(t: t, p0: previousPoint, p1: control1, p2: control2, p3: endPoint)
                    let stepPrev = bezierPoint(t: CGFloat(i-1) / CGFloat(steps), p0: previousPoint, p1: control1, p2: control2, p3: endPoint)
                    totalLength += hypot(nextPoint.x - stepPrev.x, nextPoint.y - stepPrev.y)
                }
                previousPoint = endPoint
            default:
                break
            }
        }
        
        return totalLength
    }
}

// MARK: - Bezier Helper
private func bezierPoint(t: CGFloat, p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGPoint {
    let mt = 1 - t
    let mt2 = mt * mt
    let mt3 = mt2 * mt
    let t2 = t * t
    let t3 = t2 * t
    
    return CGPoint(
        x: mt3 * p0.x + 3 * mt2 * t * p1.x + 3 * mt * t2 * p2.x + t3 * p3.x,
        y: mt3 * p0.y + 3 * mt2 * t * p1.y + 3 * mt * t2 * p2.y + t3 * p3.y
    )
}

// MARK: - Cart Tab Badge Animation
struct CartBadgeBounce: ViewModifier {
    @Binding var trigger: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(trigger ? 1.3 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: trigger)
            .onChange(of: trigger) { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        trigger = false
                    }
                }
            }
    }
}

// MARK: - Add to Cart Coordinator
class AddToCartCoordinator: ObservableObject {
    @Published var isAnimating = false
    @Published var animatingImage: GeneratedImage?
    @Published var startPosition: CGPoint = .zero
    @Published var cartBadgeCount: Int = 0
    @Published var showBadgeBounce = false
    
    func addToCart(image: GeneratedImage, from position: CGPoint) {
        animatingImage = image
        startPosition = position
        isAnimating = true
        
        // Haptic feedback
        HapticManager.shared.mediumTap()
    }
    
    func completeAnimation() {
        isAnimating = false
        animatingImage = nil
        cartBadgeCount += 1
        showBadgeBounce = true
        
        // Success haptic
        HapticManager.shared.success()
    }
}
