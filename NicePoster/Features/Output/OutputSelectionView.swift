import SwiftUI

// MARK: - Output Selection View (Light Theme - Design Matched)
struct OutputSelectionView: View {
    @Binding var cartItems: [GeneratedImage]
    let onDismiss: () -> Void
    let onPreviewMockup: () -> Void
    
    @State private var selectedPlatform: Platform = .xiaohongshu
    @State private var selectedSizes: Set<UUID> = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Cart section
                    cartSection
                    
                    // Platform tabs
                    platformTabs
                    
                    // Platform info
                    platformInfo
                    
                    // Output sizes
                    outputSizesSection
                    
                    // Bottom padding
                    Color.clear.frame(height: 100)
                }
                .padding(.top, 16)
            }
            
            // Preview Mockup button
            previewButton
        }
        .background(NPColors.bgPrimary.ignoresSafeArea())
    }
    
    // MARK: - Header
    var header: some View {
        HStack {
            Button(action: {
                HapticManager.shared.lightTap()
                onDismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(NPColors.textPrimary)
            }
            
            Spacer()
            
            Text("Output Selection")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NPColors.textPrimary)
            
            Spacer()
            
            Button(action: {
                selectedSizes.removeAll()
            }) {
                Text("Reset")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(NPColors.brandPrimary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
    
    // MARK: - Cart Section
    var cartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Cart")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(NPColors.textPrimary)
                
                Spacer()
                
                Text("\(cartItems.count) items selected")
                    .font(.system(size: 14))
                    .foregroundColor(NPColors.textSecondary)
            }
            .padding(.horizontal, 20)
            
            // Cart thumbnails
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(cartItems) { item in
                        CartThumbnail(image: item)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Platform Tabs
    var platformTabs: some View {
        HStack(spacing: 0) {
            ForEach(Platform.allCases, id: \.self) { platform in
                PlatformTab(
                    platform: platform,
                    isSelected: selectedPlatform == platform
                ) {
                    HapticManager.shared.selection()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedPlatform = platform
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Platform Info
    var platformInfo: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(NPColors.brandPrimary)
            
            Text("Content optimized for \(selectedPlatform.displayName)'s feed. Auto-cropping applied to maintain subject focus.")
                .font(.system(size: 13))
                .foregroundColor(NPColors.textSecondary)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Output Sizes Section
    var outputSizesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("OUTPUT SIZES")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(NPColors.textTertiary)
                    .tracking(0.5)
                
                Spacer()
                
                Button(action: {
                    HapticManager.shared.selection()
                    // Select all sizes for current platform
                    for size in selectedPlatform.sizes {
                        selectedSizes.insert(size.id)
                    }
                }) {
                    Text("Select All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(NPColors.brandPrimary)
                }
            }
            .padding(.horizontal, 20)
            
            // Size cards
            VStack(spacing: 12) {
                ForEach(selectedPlatform.sizes) { size in
                    SizeCard(
                        size: size,
                        isSelected: selectedSizes.contains(size.id)
                    ) {
                        HapticManager.shared.selection()
                        if selectedSizes.contains(size.id) {
                            selectedSizes.remove(size.id)
                        } else {
                            selectedSizes.insert(size.id)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Preview Button
    var previewButton: some View {
        Button(action: {
            HapticManager.shared.mediumTap()
            onPreviewMockup()
        }) {
            HStack {
                Text("Preview Mockup")
                    .font(.system(size: 17, weight: .semibold))
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(NPColors.textPrimary)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(NPColors.bgSecondary)
            .cornerRadius(16)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(NPColors.bgPrimary)
    }
}

// MARK: - Cart Thumbnail
struct CartThumbnail: View {
    let image: GeneratedImage
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(mockColor)
            .frame(width: 80, height: 80)
            .overlay(
                Image(systemName: mockIcon)
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.5))
            )
    }
    
    var mockColor: Color {
        switch image.imageName {
        case "cake": return Color(red: 0.4, green: 0.25, blue: 0.2)
        case "coffee": return Color(red: 0.3, green: 0.2, blue: 0.15)
        default: return Color.gray.opacity(0.3)
        }
    }
    
    var mockIcon: String {
        switch image.imageName {
        case "cake": return "birthday.cake.fill"
        case "coffee": return "cup.and.saucer.fill"
        default: return "photo"
        }
    }
}

// MARK: - Platform Tab
struct PlatformTab: View {
    let platform: Platform
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isSelected {
                    Circle()
                        .fill(platform.color)
                        .frame(width: 8, height: 8)
                }
                
                Text(platform.displayName)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? NPColors.textPrimary : NPColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? NPColors.bgSecondary : Color.clear)
            .cornerRadius(20)
        }
    }
}

// MARK: - Size Card
struct SizeCard: View {
    let size: OutputSize
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Aspect ratio preview
                RoundedRectangle(cornerRadius: 6)
                    .stroke(NPColors.textTertiary.opacity(0.3), lineWidth: 1)
                    .frame(width: 44, height: 44 * size.aspectRatioValue)
                    .frame(width: 44, height: 44)
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(size.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(NPColors.textPrimary)
                    
                    Text("\(size.ratio) Ratio • \(size.description)")
                        .font(.system(size: 13))
                        .foregroundColor(NPColors.textSecondary)
                }
                
                Spacer()
                
                // Checkbox
                ZStack {
                    Circle()
                        .stroke(isSelected ? NPColors.brandPrimary : NPColors.textTertiary.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(NPColors.brandPrimary)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
            .padding(16)
            .background(NPColors.bgPrimary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? NPColors.brandPrimary : NPColors.textTertiary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

// MARK: - Platform Enum
enum Platform: CaseIterable {
    case xiaohongshu
    case douyin
    case wechat
    
    var displayName: String {
        switch self {
        case .xiaohongshu: return "XiaoHongShu"
        case .douyin: return "Douyin"
        case .wechat: return "WeChat"
        }
    }
    
    var color: Color {
        switch self {
        case .xiaohongshu: return Color.red
        case .douyin: return Color.black
        case .wechat: return Color.green
        }
    }
    
    var sizes: [OutputSize] {
        switch self {
        case .xiaohongshu:
            return [
                OutputSize(name: "Vertical Cover", ratio: "3:4", description: "Best for notes", aspectRatioValue: 1.33),
                OutputSize(name: "Square Post", ratio: "1:1", description: "Carousel detail", aspectRatioValue: 1.0),
                OutputSize(name: "Story / Reel", ratio: "9:16", description: "Immersive video", aspectRatioValue: 1.78)
            ]
        case .douyin:
            return [
                OutputSize(name: "Video Cover", ratio: "9:16", description: "Full screen", aspectRatioValue: 1.78),
                OutputSize(name: "Group Buy", ratio: "16:9", description: "Landscape", aspectRatioValue: 0.56),
                OutputSize(name: "Store Album", ratio: "4:3", description: "Gallery view", aspectRatioValue: 0.75)
            ]
        case .wechat:
            return [
                OutputSize(name: "Moments", ratio: "1:1", description: "Square post", aspectRatioValue: 1.0),
                OutputSize(name: "Article Cover", ratio: "2.35:1", description: "Wide banner", aspectRatioValue: 0.43),
                OutputSize(name: "Mini Program", ratio: "5:4", description: "Product card", aspectRatioValue: 0.8)
            ]
        }
    }
}

// MARK: - Output Size Model
struct OutputSize: Identifiable {
    let id = UUID()
    let name: String
    let ratio: String
    let description: String
    let aspectRatioValue: CGFloat
}
