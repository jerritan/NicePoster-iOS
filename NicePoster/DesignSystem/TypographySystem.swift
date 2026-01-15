import SwiftUI

// MARK: - Typography System
struct NPTypography {
    
    // Display Styles (Titles)
    static func hero(_ text: String) -> Text {
        Text(text).font(.system(size: 34, weight: .bold, design: .default))
    }
    
    static func title1(_ text: String) -> Text {
        Text(text).font(.system(size: 28, weight: .bold, design: .default))
    }
    
    static func title2(_ text: String) -> Text {
        Text(text).font(.system(size: 22, weight: .bold, design: .default))
    }
    
    static func title3(_ text: String) -> Text {
        Text(text).font(.system(size: 20, weight: .semibold, design: .default))
    }
    
    // Body Styles
    static func body(_ text: String) -> Text {
        Text(text).font(.system(size: 17, weight: .regular, design: .default))
    }
    
    static func callout(_ text: String) -> Text {
        Text(text).font(.system(size: 16, weight: .regular, design: .default))
    }
    
    static func subhead(_ text: String) -> Text {
        Text(text).font(.system(size: 15, weight: .regular, design: .default))
    }
    
    static func footnote(_ text: String) -> Text {
        Text(text).font(.system(size: 13, weight: .regular, design: .default))
    }
    
    static func caption(_ text: String) -> Text {
        Text(text).font(.system(size: 12, weight: .regular, design: .default))
    }
}

// MARK: - View Modifiers for Text
struct NPTextStyle: ViewModifier {
    let style: Font.TextStyle
    let weight: Font.Weight
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(style, design: .default).weight(weight))
            .foregroundColor(color)
    }
}

extension View {
    func styleHero(color: Color = NPColors.textPrimary) -> some View {
        modifier(NPTextStyle(style: .largeTitle, weight: .bold, color: color))
    }
    
    func styleTitle1(color: Color = NPColors.textPrimary) -> some View {
        modifier(NPTextStyle(style: .title, weight: .bold, color: color))
    }
    
    func styleBody(color: Color = NPColors.textPrimary) -> some View {
        modifier(NPTextStyle(style: .body, weight: .regular, color: color))
    }
    
    func styleCaption(color: Color = NPColors.textSecondary) -> some View {
        modifier(NPTextStyle(style: .caption, weight: .regular, color: color))
    }
}
