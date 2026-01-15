import SwiftUI

// MARK: - Inspiration Card Data Model
struct InspirationItem: Identifiable {
    let id = UUID()
    let title: String
    let tag: String
    let tagColor: Color
    let imageName: String
    let isHot: Bool
    let aspectRatio: CGFloat // height / width ratio for masonry
}

// MARK: - Mock Inspirations (matching design)
let mockInspirations: [InspirationItem] = [
    InspirationItem(
        title: "Valentine's Promotion",
        tag: "Seasonal",
        tagColor: .pink,
        imageName: "valentine",
        isHot: true,
        aspectRatio: 1.4
    ),
    InspirationItem(
        title: "Weekend Special",
        tag: "Limited Time",
        tagColor: .orange,
        imageName: "breakfast",
        isHot: false,
        aspectRatio: 0.9
    ),
    InspirationItem(
        title: "New Drink Launch",
        tag: "Menu",
        tagColor: .green,
        imageName: "cocktail",
        isHot: false,
        aspectRatio: 1.5
    ),
    InspirationItem(
        title: "Social Media Post",
        tag: "Engagement",
        tagColor: .blue,
        imageName: "social",
        isHot: false,
        aspectRatio: 0.85
    ),
    InspirationItem(
        title: "Our Story",
        tag: "Branding",
        tagColor: .purple,
        imageName: "story",
        isHot: false,
        aspectRatio: 0.7
    ),
    InspirationItem(
        title: "Spicy Noodles",
        tag: "New Item",
        tagColor: .red,
        imageName: "noodles",
        isHot: true,
        aspectRatio: 1.2
    )
]

// MARK: - Masonry Inspiration Grid
struct InspirationMasonryGrid: View {
    let items: [InspirationItem]
    let onSelect: (InspirationItem) -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left column
            VStack(spacing: 12) {
                ForEach(Array(items.enumerated()).filter { $0.offset % 2 == 0 }, id: \.element.id) { _, item in
                    InspirationImageCard(item: item) {
                        onSelect(item)
                    }
                }
            }
            
            // Right column
            VStack(spacing: 12) {
                ForEach(Array(items.enumerated()).filter { $0.offset % 2 == 1 }, id: \.element.id) { _, item in
                    InspirationImageCard(item: item) {
                        onSelect(item)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Inspiration Image Card (Design-matched)
struct InspirationImageCard: View {
    let item: InspirationItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // Image area with HOT badge
                ZStack(alignment: .topLeading) {
                    // Mock image placeholder
                    mockImage
                        .frame(height: 120 * item.aspectRatio)
                        .clipped()
                    
                    // HOT badge
                    if item.isHot {
                        Text("HOT")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .cornerRadius(4)
                            .padding(8)
                    }
                }
                .cornerRadius(NPRadius.medium, corners: [.topLeft, .topRight])
                
                // Title and tag area
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(NPColors.textPrimary)
                        .lineLimit(1)
                    
                    HStack {
                        Text(item.tag)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(item.tagColor)
                        
                        Spacer()
                        
                        if item.tag == "Seasonal" {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.pink.opacity(0.6))
                        }
                    }
                }
                .padding(12)
                .background(NPColors.bgPrimary)
                .cornerRadius(NPRadius.medium, corners: [.bottomLeft, .bottomRight])
            }
            .background(NPColors.bgPrimary)
            .cornerRadius(NPRadius.medium)
            .shadow(color: NPShadow.shadow2.color, radius: NPShadow.shadow2.radius, x: 0, y: NPShadow.shadow2.y)
        }
        .buttonStyle(CardButtonStyle())
    }
    
    @ViewBuilder
    var mockImage: some View {
        switch item.imageName {
        case "valentine":
            ZStack {
                Color(red: 0.5, green: 0.15, blue: 0.2)
                Image(systemName: "wineglass.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.3))
            }
        case "breakfast":
            ZStack {
                Color(red: 0.95, green: 0.9, blue: 0.85)
                Image(systemName: "fork.knife")
                    .font(.system(size: 40))
                    .foregroundColor(.orange.opacity(0.4))
            }
        case "cocktail":
            ZStack {
                Color(red: 0.1, green: 0.15, blue: 0.2)
                Image(systemName: "wineglass")
                    .font(.system(size: 40))
                    .foregroundColor(.green.opacity(0.5))
            }
        case "social":
            ZStack {
                Color(red: 0.95, green: 0.85, blue: 0.8)
                Image(systemName: "camera.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.pink.opacity(0.4))
            }
        case "story":
            ZStack {
                Color(red: 0.9, green: 0.85, blue: 0.75)
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow.opacity(0.5))
            }
        case "noodles":
            ZStack {
                Color(red: 0.2, green: 0.15, blue: 0.1)
                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange.opacity(0.5))
            }
        default:
            Color.gray.opacity(0.3)
        }
    }
}

// MARK: - Card Button Style
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Mock Image Helper
@ViewBuilder
func mockImageForName(_ imageName: String) -> some View {
    switch imageName {
    case "valentine":
        ZStack {
            Color(red: 0.5, green: 0.15, blue: 0.2)
            Image(systemName: "wineglass.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.3))
        }
    case "breakfast":
        ZStack {
            Color(red: 0.95, green: 0.9, blue: 0.85)
            Image(systemName: "fork.knife")
                .font(.system(size: 40))
                .foregroundColor(.orange.opacity(0.4))
        }
    case "cocktail":
        ZStack {
            Color(red: 0.1, green: 0.15, blue: 0.2)
            Image(systemName: "wineglass")
                .font(.system(size: 40))
                .foregroundColor(.green.opacity(0.5))
        }
    case "social":
        ZStack {
            Color(red: 0.95, green: 0.85, blue: 0.8)
            Image(systemName: "camera.fill")
                .font(.system(size: 40))
                .foregroundColor(.pink.opacity(0.4))
        }
    case "story":
        ZStack {
            Color(red: 0.9, green: 0.85, blue: 0.75)
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 40))
                .foregroundColor(.yellow.opacity(0.5))
        }
    case "noodles":
        ZStack {
            Color(red: 0.2, green: 0.15, blue: 0.1)
            Image(systemName: "flame.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange.opacity(0.5))
        }
    default:
        Color.gray.opacity(0.3)
    }
}

// MARK: - Compact Inspiration Card (Horizontal Scroll)
struct InspirationCardCompact: View {
    let item: InspirationItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // Image Area
                ZStack(alignment: .topLeading) {
                    mockImageForName(item.imageName)
                        .frame(width: 160, height: 120)
                        .clipped()
                    
                    // HOT Badge
                    if item.isHot {
                        Text("HOT")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .cornerRadius(4)
                            .padding(8)
                    }
                }
                
                // Text Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(NPColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(item.tag)
                        .font(.system(size: 12))
                        .foregroundColor(NPColors.textTertiary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .background(NPColors.bgSecondary)
            .cornerRadius(12)
            .shadow(color: NPShadow.shadow1.color, radius: NPShadow.shadow1.radius, x: 0, y: NPShadow.shadow1.y)
        }
        .buttonStyle(CardButtonStyle())
    }
}
