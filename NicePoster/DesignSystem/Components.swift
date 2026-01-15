import SwiftUI

// MARK: - Components
struct NPButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var style: ButtonStyle = .primary
    
    enum ButtonStyle {
        case primary
        case secondary
        case ghost
    }
    
    var body: some View {
        Button(action: {
            HapticManager.shared.mediumTap()
            action()
        }) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(backgroundView)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .shadow(color: shadowColor, radius: style == .primary ? 4 : 0, x: 0, y: 2)
        }
        .buttonStyle(NPButtonStyle())
    }
    
    // Helper properties for styling
    @Environment(\.colorScheme) var colorScheme
    
    private var backgroundView: some View {
        switch style {
        case .primary:
            return AnyView(NPColors.brandGradient)
        case .secondary:
            return AnyView(colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.95))
        case .ghost:
            return AnyView(Color.clear)
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return NPColors.textPrimary
        case .ghost:
            return NPColors.brandPrimary
        }
    }
    
    private var shadowColor: Color {
        style == .primary ? NPColors.brandPrimary.opacity(0.3) : .clear
    }
}

// Custom Button Style to access isPressed state
struct NPButtonStyle: SwiftUI.ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
