import SwiftUI

// MARK: - Campaign Quick Peek Overlay (Light Theme)
struct CampaignQuickPeek: View {
    let campaign: Campaign
    let onDismiss: () -> Void
    let onQuickShare: () -> Void
    let onCopyPrompt: () -> Void
    let onEditAssets: () -> Void
    let onViewDetails: () -> Void
    
    @State private var showContent = false
    @State private var showBubbles = false
    @State private var showMenu = false
    
    var body: some View {
        ZStack {
            // Blurred Background
            Color.black.opacity(0.4)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissWithAnimation()
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Main Card with Platform Bubbles
                ZStack {
                    // Platform Preview Bubbles
                    platformBubbles
                    
                    // Main Preview Card
                    mainPreviewCard
                }
                .scaleEffect(showContent ? 1.0 : 0.8)
                .opacity(showContent ? 1.0 : 0)
                
                Spacer()
                
                // Quick Actions Menu
                quickActionsMenu
                    .offset(y: showMenu ? 0 : 200)
                    .opacity(showMenu ? 1 : 0)
            }
        }
        .onAppear {
            HapticManager.shared.mediumTap()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                showContent = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
                showBubbles = true
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.2)) {
                showMenu = true
            }
        }
    }
    
    // MARK: - Platform Preview Bubbles
    var platformBubbles: some View {
        ZStack {
            // Top Left - IG Post
            PlatformBubble(
                icon: "camera.fill",
                label: "IG POST",
                color: Color.pink,
                offset: CGSize(width: -130, height: -180),
                delay: 0.1
            )
            .opacity(showBubbles ? 1 : 0)
            .offset(x: showBubbles ? 0 : 50, y: showBubbles ? 0 : 50)
            
            // Top Right - Story
            PlatformBubble(
                icon: "rectangle.portrait.fill",
                label: "Story",
                color: Color.purple,
                offset: CGSize(width: 130, height: -140),
                delay: 0.15
            )
            .opacity(showBubbles ? 1 : 0)
            .offset(x: showBubbles ? 0 : -50, y: showBubbles ? 0 : 50)
            
            // Bottom Left - Banner
            PlatformBubble(
                icon: "rectangle.fill",
                label: "Banner",
                color: Color.orange,
                offset: CGSize(width: -140, height: 100),
                delay: 0.2
            )
            .opacity(showBubbles ? 1 : 0)
            .offset(x: showBubbles ? 0 : 50, y: showBubbles ? 0 : -50)
            
            // Bottom Right - Video
            PlatformBubble(
                icon: "play.rectangle.fill",
                label: "Video",
                color: Color.blue,
                offset: CGSize(width: 140, height: 140),
                delay: 0.25
            )
            .opacity(showBubbles ? 1 : 0)
            .offset(x: showBubbles ? 0 : -50, y: showBubbles ? 0 : -50)
        }
    }
    
    // MARK: - Main Preview Card
    var mainPreviewCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Preview
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(campaign.backgroundColor)
                    .frame(width: 280, height: 320)
                
                campaign.mockImageView
                    .frame(width: 280, height: 320)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 15)
            
            // Title & Info
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    // Rating Badge
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                        Text("4.0")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(NPColors.textSecondary)
                    .cornerRadius(12)
                    
                    // Active Preview Badge
                    Text("ACTIVE PREVIEW")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(NPColors.textSecondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(NPColors.bgTertiary)
                        .cornerRadius(12)
                }
                
                Text(campaign.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(NPColors.textPrimary)
                
                Text("NicePoster AI Campaign")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NPColors.brandPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.15), radius: 40, x: 0, y: 20)
        )
    }
    
    // MARK: - Quick Actions Menu
    var quickActionsMenu: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("QUICK ACTIONS")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(NPColors.textSecondary)
                Spacer()
                Circle()
                    .fill(NPColors.brandPrimary)
                    .frame(width: 8, height: 8)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            // Action Items
            VStack(spacing: 0) {
                QuickActionItem(
                    icon: "square.and.arrow.up",
                    iconColor: NPColors.brandPrimary,
                    title: "Quick Share",
                    subtitle: "Export to social media",
                    action: onQuickShare
                )
                
                Divider()
                    .padding(.leading, 60)
                
                QuickActionItem(
                    icon: "doc.on.doc",
                    iconColor: Color.pink,
                    title: "Copy Prompt",
                    subtitle: "\"\(campaign.title)...\"",
                    action: onCopyPrompt
                )
                
                Divider()
                    .padding(.leading, 60)
                
                QuickActionItem(
                    icon: "pencil",
                    iconColor: Color.blue,
                    title: "Edit Assets",
                    subtitle: "Modify generated variations",
                    action: onEditAssets
                )
            }
            
            // View All Details Button
            Button(action: onViewDetails) {
                HStack {
                    Text("View All Details")
                        .font(.system(size: 16, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(NPColors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(NPColors.brandPrimary.opacity(0.15))
                .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: -10)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private func dismissWithAnimation() {
        HapticManager.shared.lightTap()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showMenu = false
            showBubbles = false
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8).delay(0.1)) {
            showContent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}

// MARK: - Platform Bubble
struct PlatformBubble: View {
    let icon: String
    let label: String
    let color: Color
    let offset: CGSize
    let delay: Double
    
    var body: some View {
        VStack(spacing: 4) {
            // Thumbnail
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.2))
                .frame(width: 50, height: 60)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                )
                .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
            
            // Label
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(color)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .offset(offset)
    }
}

// MARK: - Quick Action Item
struct QuickActionItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
            action()
        }) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 28)
                
                // Text
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(NPColors.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(NPColors.textTertiary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NPColors.textTertiary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
    }
}

// MARK: - Preview
#Preview {
    CampaignQuickPeek(
        campaign: Campaign.mockData[0],
        onDismiss: {},
        onQuickShare: {},
        onCopyPrompt: {},
        onEditAssets: {},
        onViewDetails: {}
    )
}
