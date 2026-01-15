import SwiftUI

// MARK: - Color System (Apple Design Awards Level)
struct NPColors {
    // Brand Colors
    static let brandPrimary = Color(hex: "22D3EE") // Cyan 400
    static let brandSecondary = Color(hex: "0EA5E9") // Sky 500
    static let brandAccent = Color(hex: "8B5CF6") // Violet 500
    static let brandGreen = Color(hex: "A8E063") // Logo green
    
    static var brandGradient: LinearGradient {
        LinearGradient(
            colors: [brandPrimary, brandAccent],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // iOS System Colors
    static let iosBlue = Color(hex: "0A84FF")
    static let iosGreen = Color(hex: "30D158")
    
    // Status Colors
    static let success = Color(hex: "10B981")
    static let warning = Color(hex: "F59E0B")
    static let error = Color(hex: "EF4444")
    
    // Light Theme Colors (小红书 Style)
    struct Light {
        static let bgPrimary = Color.white
        static let bgSecondary = Color(hex: "F8F9FA")
        static let bgTertiary = Color(hex: "F1F3F5")
        static let textPrimary = Color(hex: "1A1A1A")
        static let textSecondary = Color(hex: "6B7280")
        static let textTertiary = Color(hex: "9CA3AF")
    }
    
    // Dark Theme Colors (抖音 Style)
    struct Dark {
        static let bgPrimary = Color.black
        static let bgSecondary = Color(hex: "1C1C1E")
        static let bgTertiary = Color(hex: "2C2C2E")
        static let textPrimary = Color.white
        static let textSecondary = Color(hex: "8E8E93")
        static let textTertiary = Color(hex: "636366")
    }
    
    // Semantic Background Colors (Auto-switch)
    static var bgPrimary: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        })
    }
    
    static var bgSecondary: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "1C1C1E") : UIColor(hex: "F8F9FA")
        })
    }
    
    static var bgTertiary: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "2C2C2E") : UIColor(hex: "F1F3F5")
        })
    }
    
    // Semantic Text Colors (Auto-switch)
    static var textPrimary: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor.white : UIColor(hex: "1A1A1A")
        })
    }
    
    static var textSecondary: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "8E8E93") : UIColor(hex: "6B7280")
        })
    }
    
    static var textTertiary: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "636366") : UIColor(hex: "9CA3AF")
        })
    }
    
    // Glassmorphism
    static var glassBackground: some View {
        Color.white.opacity(0.8)
            .background(.ultraThinMaterial)
    }
}

// MARK: - Spacing System (8pt Grid)
struct NPSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}

// MARK: - Corner Radius System
struct NPRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 24
    static let full: CGFloat = 9999
}

// MARK: - Shadow System
struct NPShadow {
    static func elevation1() -> some View {
        Color.black.opacity(0.05)
    }
    
    static let shadow1 = (color: Color.black.opacity(0.05), radius: CGFloat(2), y: CGFloat(1))
    static let shadow2 = (color: Color.black.opacity(0.08), radius: CGFloat(8), y: CGFloat(4))
    static let shadow3 = (color: Color.black.opacity(0.12), radius: CGFloat(16), y: CGFloat(8))
    static let shadow4 = (color: Color.black.opacity(0.16), radius: CGFloat(32), y: CGFloat(16))
}

// MARK: - UIColor Hex Extension
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

// MARK: - Color Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
