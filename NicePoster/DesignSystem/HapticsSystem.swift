import SwiftUI
import CoreHaptics

// MARK: - Haptics System
class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func play(_ feedback: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: feedback)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    // Custom Semantic Feedbacks
    func success() {
        notify(.success)
    }
    
    func error() {
        notify(.error)
    }
    
    func warning() {
        notify(.warning)
    }
    
    func lightTap() {
        play(.light)
    }
    
    func mediumTap() {
        play(.medium)
    }
    
    func heavyTap() {
        play(.heavy)
    }
}

// MARK: - View Modifier
struct HapticButtonModifier: ViewModifier {
    let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
    
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            TapGesture().onEnded { _ in
                HapticManager.shared.play(feedbackStyle)
            }
        )
    }
}

extension View {
    func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        modifier(HapticButtonModifier(feedbackStyle: style))
    }
}
