import SwiftUI

// MARK: - Campaign Details View
struct CampaignDetailsView: View {
    let campaign: Campaign
    @Environment(\.dismiss) private var dismiss
    
    @State private var sessions: [GenerationSession] = GenerationSession.mockData
    @State private var selectedImages: Set<UUID> = []
    @State private var showBubbleCart = false
    @State private var isGenerating = true
    @State private var generationProgress: CGFloat = 0.75
    
    var body: some View {
        ZStack {
            NPColors.bgPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Header
                header
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Campaign Info
                        campaignInfo
                        
                        // Active Session (if generating)
                        if isGenerating {
                            activeSessionCard
                        }
                        
                        // Session History
                        sessionHistory
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, selectedImages.isEmpty ? 20 : 100)
                }
            }
            
            // View Selected Floating Bar
            if !selectedImages.isEmpty {
                VStack {
                    Spacer()
                    viewSelectedBar
                }
            }
        }
        .fullScreenCover(isPresented: $showBubbleCart) {
            BubbleCartView(
                cartItems: .constant(selectedImagesAsGeneratedImages),
                onExport: { showBubbleCart = false }
            )
        }
    }
    
    // MARK: - Header
    var header: some View {
        HStack {
            Button(action: {
                HapticManager.shared.lightTap()
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(NPColors.textPrimary)
            }
            
            Spacer()
            
            Text("Campaign Details")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(NPColors.textPrimary)
            
            Spacer()
            
            Button(action: {
                HapticManager.shared.lightTap()
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(NPColors.textPrimary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
    
    // MARK: - Campaign Info
    var campaignInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(campaign.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(NPColors.textPrimary)
            
            HStack(spacing: 12) {
                // Status Badge
                HStack(spacing: 6) {
                    Circle()
                        .fill(campaign.status == .live ? Color.green : NPColors.textTertiary)
                        .frame(width: 8, height: 8)
                    Text(campaign.status.displayName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(campaign.status == .live ? Color.green : NPColors.textTertiary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    (campaign.status == .live ? Color.green : NPColors.textTertiary).opacity(0.1)
                )
                .cornerRadius(8)
                
                // Model Info
                Text("Feb 14 Campaign • V4.2 Model")
                    .font(.system(size: 13))
                    .foregroundColor(NPColors.textSecondary)
            }
        }
    }
    
    // MARK: - Active Session Card
    var activeSessionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.3))
                Text("ACTIVE SESSION")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.3))
                    .tracking(0.8)
                
                Spacer()
                
                // Animated indicator
                Circle()
                    .fill(Color(red: 1.0, green: 0.4, blue: 0.3))
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(Color(red: 1.0, green: 0.4, blue: 0.3).opacity(0.3), lineWidth: 3)
                            .scaleEffect(1.5)
                    )
            }
            
            Text("Generating\nVariations...")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(NPColors.textPrimary)
                .lineSpacing(4)
            
            // Progress
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Analyzing prompts")
                        .font(.system(size: 13))
                        .foregroundColor(NPColors.textSecondary)
                    Spacer()
                    Text("\(Int(generationProgress * 100))%")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(NPColors.textSecondary)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(NPColors.bgTertiary)
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.4, blue: 0.3), Color(red: 1.0, green: 0.6, blue: 0.4)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * generationProgress, height: 6)
                    }
                }
                .frame(height: 6)
            }
            
            Text("Using V4.2 depth model to create parallax-ready assets. **Approx 12s remaining**.")
                .font(.system(size: 12))
                .foregroundColor(NPColors.textTertiary)
        }
        .padding(20)
        .background(NPColors.bgSecondary)
        .cornerRadius(20)
    }
    
    // MARK: - Session History
    var sessionHistory: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Session History")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(NPColors.textPrimary)
                
                Spacer()
                
                Button(action: {
                    HapticManager.shared.lightTap()
                }) {
                    Text("Clear All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.3))
                }
            }
            
            ForEach(sessions) { session in
                SessionCard(
                    session: session,
                    selectedImages: $selectedImages
                )
            }
        }
    }
    
    // MARK: - View Selected Bar
    var viewSelectedBar: some View {
        Button(action: {
            HapticManager.shared.mediumTap()
            showBubbleCart = true
        }) {
            HStack {
                Text("View Selected")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("\(selectedImages.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.3))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.white)
                    .cornerRadius(12)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color(red: 1.0, green: 0.45, blue: 0.4), Color(red: 1.0, green: 0.55, blue: 0.5)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(28)
            .shadow(color: Color(red: 1.0, green: 0.45, blue: 0.4).opacity(0.4), radius: 16, x: 0, y: 8)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
    
    private var selectedImagesAsGeneratedImages: [GeneratedImage] {
        sessions.flatMap { $0.variations }
            .filter { selectedImages.contains($0.id) }
            .map { GeneratedImage(imageName: $0.imageName, mockColor: $0.color, mockIcon: $0.icon) }
    }
}

// MARK: - Session Card
struct SessionCard: View {
    let session: GenerationSession
    @Binding var selectedImages: Set<UUID>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Status Icon
                ZStack {
                    Circle()
                        .fill(session.status == .completed ? Color.green.opacity(0.1) : NPColors.bgTertiary)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: session.status == .completed ? "checkmark" : "clock")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(session.status == .completed ? Color.green : NPColors.textTertiary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Session #\(session.number)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(NPColors.textPrimary)
                    
                    Text("\(session.timeAgo) • \(session.variations.count) Variations")
                        .font(.system(size: 12))
                        .foregroundColor(NPColors.textTertiary)
                }
                
                Spacer()
                
                Button(action: {
                    HapticManager.shared.lightTap()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                        .foregroundColor(NPColors.textTertiary)
                }
            }
            
            // Variations Grid
            if session.status == .completed {
                HStack(spacing: 8) {
                    ForEach(session.variations.prefix(3)) { variation in
                        VariationThumbnail(
                            variation: variation,
                            isSelected: selectedImages.contains(variation.id),
                            onToggle: {
                                toggleSelection(variation.id)
                            }
                        )
                    }
                }
            }
        }
        .padding(16)
        .background(NPColors.bgSecondary)
        .cornerRadius(16)
    }
    
    private func toggleSelection(_ id: UUID) {
        HapticManager.shared.lightTap()
        if selectedImages.contains(id) {
            selectedImages.remove(id)
        } else {
            selectedImages.insert(id)
        }
    }
}

// MARK: - Variation Thumbnail
struct VariationThumbnail: View {
    let variation: SessionVariation
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 12)
                .fill(variation.color)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Image(systemName: variation.icon)
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.4))
                )
            
            // Selection indicator
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color(red: 1.0, green: 0.4, blue: 0.3) : .white.opacity(0.9))
                        .frame(width: 24, height: 24)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .offset(x: -6, y: 6)
        }
    }
}

// MARK: - Generation Session Model
struct GenerationSession: Identifiable {
    let id = UUID()
    let number: Int
    let timeAgo: String
    let status: SessionStatus
    let variations: [SessionVariation]
    
    enum SessionStatus {
        case completed
        case failed
        case inProgress
    }
    
    static let mockData: [GenerationSession] = [
        GenerationSession(
            number: 3,
            timeAgo: "10 mins ago",
            status: .completed,
            variations: [
                SessionVariation(color: Color(red: 0.9, green: 0.85, blue: 0.8), icon: "leaf.fill"),
                SessionVariation(color: Color(red: 0.95, green: 0.85, blue: 0.85), icon: "heart.fill"),
                SessionVariation(color: Color(red: 0.2, green: 0.15, blue: 0.25), icon: "bolt.fill")
            ]
        ),
        GenerationSession(
            number: 2,
            timeAgo: "1 hour ago",
            status: .completed,
            variations: [
                SessionVariation(color: Color(red: 0.95, green: 0.9, blue: 0.85), icon: "car.fill"),
                SessionVariation(color: Color(red: 0.9, green: 0.8, blue: 0.7), icon: "person.2.fill"),
                SessionVariation(color: Color(red: 0.95, green: 0.9, blue: 0.8), icon: "birthday.cake.fill")
            ]
        ),
        GenerationSession(
            number: 1,
            timeAgo: "2 hours ago",
            status: .failed,
            variations: []
        )
    ]
}

// MARK: - Session Variation Model
struct SessionVariation: Identifiable {
    let id = UUID()
    let imageName: String = "variation"
    let color: Color
    let icon: String
}

// MARK: - Preview
#Preview {
    CampaignDetailsView(campaign: Campaign.mockData[0])
}
