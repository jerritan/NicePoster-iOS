import SwiftUI

// MARK: - Campaign List View (Your Story) - Light Theme
struct CampaignListView: View {
    @State private var selectedFilter: CampaignFilter = .all
    @State private var campaigns: [Campaign] = Campaign.mockData
    @State private var searchText: String = ""
    @State private var selectedCampaign: Campaign?
    @State private var showQuickPeek = false
    @State private var showCampaignDetails = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                header
                
                // Filter Tabs
                filterTabs
                
                // Campaign Grid
                ScrollView {
                    campaignGrid
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100) // Space for tab bar
                }
            }
            .background(NPColors.bgPrimary.ignoresSafeArea())
            
            // Quick Peek Overlay
            if showQuickPeek, let campaign = selectedCampaign {
                CampaignQuickPeek(
                    campaign: campaign,
                    onDismiss: { showQuickPeek = false },
                    onQuickShare: {
                        HapticManager.shared.success()
                        showQuickPeek = false
                    },
                    onCopyPrompt: {
                        HapticManager.shared.success()
                        showQuickPeek = false
                    },
                    onEditAssets: {
                        HapticManager.shared.success()
                        showQuickPeek = false
                    },
                    onViewDetails: {
                        showQuickPeek = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showCampaignDetails = true
                        }
                    }
                )
                .transition(.opacity)
            }
        }
        .fullScreenCover(isPresented: $showCampaignDetails) {
            if let campaign = selectedCampaign {
                CampaignDetailsView(campaign: campaign)
            }
        }
    }
    
    // MARK: - Header (Light Theme)
    var header: some View {
        HStack {
            // User Avatar
            Circle()
                .fill(NPColors.brandGradient)
                .frame(width: 40, height: 40)
                .overlay(
                    Text("J")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                )
            
            Text("Your Story")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(NPColors.textPrimary)
            
            Spacer()
            
            // Search Button
            Button(action: {
                HapticManager.shared.lightTap()
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(NPColors.textSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(NPColors.bgPrimary)
    }
    
    // MARK: - Filter Tabs
    var filterTabs: some View {
        HStack(spacing: 8) {
            ForEach(CampaignFilter.allCases, id: \.self) { filter in
                FilterTab(
                    title: filter.displayName,
                    count: filter == .drafts ? 4 : nil,
                    isSelected: selectedFilter == filter
                ) {
                    HapticManager.shared.selection()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedFilter = filter
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
    
    // MARK: - Campaign Grid
    var campaignGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
        
        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(filteredCampaigns) { campaign in
                CampaignCard(campaign: campaign) {
                    selectedCampaign = campaign
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showQuickPeek = true
                    }
                }
            }
        }
    }
    
    var filteredCampaigns: [Campaign] {
        switch selectedFilter {
        case .all:
            return campaigns
        case .drafts:
            return campaigns.filter { $0.status == .draft }
        case .published:
            return campaigns.filter { $0.status == .live || $0.status == .archived }
        }
    }
}

// MARK: - Campaign Filter
enum CampaignFilter: CaseIterable {
    case all
    case drafts
    case published
    
    var displayName: String {
        switch self {
        case .all: return "All Campaigns"
        case .drafts: return "Drafts"
        case .published: return "Published"
        }
    }
}

// MARK: - Filter Tab (Light Theme)
struct FilterTab: View {
    let title: String
    var count: Int? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                if let count = count {
                    Text("(\(count))")
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .foregroundColor(isSelected ? NPColors.textPrimary : NPColors.textTertiary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? NPColors.bgTertiary : Color.clear)
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : NPColors.textTertiary.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Campaign Card (Light Theme)
struct CampaignCard: View {
    let campaign: Campaign
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
            onTap()
        }) {
        VStack(alignment: .leading, spacing: 0) {
            // Image Area
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(campaign.backgroundColor)
                    .aspectRatio(campaign.isLarge ? 0.85 : 1.0, contentMode: .fit)
                
                // Mock Image Content
                campaign.mockImageView
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Title & Status
            VStack(alignment: .leading, spacing: 6) {
                Text(campaign.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(NPColors.textPrimary)
                
                HStack(spacing: 8) {
                    // Status Badge
                    Text(campaign.status.displayName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(campaign.status.textColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(campaign.status.backgroundColor)
                        .cornerRadius(4)
                    
                    // Additional Info
                    if let info = campaign.additionalInfo {
                        Text(info)
                            .font(.system(size: 12))
                            .foregroundColor(NPColors.textTertiary)
                    }
                }
            }
            .padding(.top, 12)
        }
        .padding(12)
        .background(NPColors.bgSecondary)
        .cornerRadius(20)
        .shadow(color: NPShadow.shadow1.color, radius: NPShadow.shadow1.radius, x: 0, y: NPShadow.shadow1.y)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Campaign Model
struct Campaign: Identifiable {
    let id = UUID()
    let title: String
    let status: CampaignStatus
    let backgroundColor: Color
    let additionalInfo: String?
    let isLarge: Bool
    let mockImageType: MockImageType
    
    enum MockImageType {
        case neonCircle
        case techSpheres
        case feathers
        case gradient
    }
    
    @ViewBuilder
    var mockImageView: some View {
        switch mockImageType {
        case .neonCircle:
            ZStack {
                Image(systemName: "circle")
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundColor(.pink)
                    .shadow(color: .pink, radius: 20)
            }
        case .techSpheres:
            ZStack {
                Image(systemName: "atom")
                    .font(.system(size: 50))
                    .foregroundColor(.brown.opacity(0.7))
            }
        case .feathers:
            ZStack {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.brown.opacity(0.4))
                    .rotationEffect(.degrees(-30))
            }
        case .gradient:
            LinearGradient(
                colors: [.pink, .purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    static let mockData: [Campaign] = [
        Campaign(
            title: "Neon Dreams",
            status: .live,
            backgroundColor: Color(red: 0.1, green: 0.15, blue: 0.3),
            additionalInfo: "2h ago",
            isLarge: true,
            mockImageType: .neonCircle
        ),
        Campaign(
            title: "Tech Launch",
            status: .assets(12),
            backgroundColor: Color(red: 0.1, green: 0.2, blue: 0.2),
            additionalInfo: nil,
            isLarge: false,
            mockImageType: .techSpheres
        ),
        Campaign(
            title: "Summer '24",
            status: .draft,
            backgroundColor: Color(red: 0.95, green: 0.95, blue: 0.95),
            additionalInfo: "85% Ready",
            isLarge: false,
            mockImageType: .feathers
        ),
        Campaign(
            title: "Retrowave",
            status: .archived,
            backgroundColor: Color(red: 0.2, green: 0.2, blue: 0.25),
            additionalInfo: nil,
            isLarge: false,
            mockImageType: .gradient
        )
    ]
}

// MARK: - Campaign Status
enum CampaignStatus: Equatable {
    case live
    case draft
    case archived
    case assets(Int)
    
    var displayName: String {
        switch self {
        case .live: return "LIVE"
        case .draft: return "DRAFT"
        case .archived: return "ARCHIVED"
        case .assets(let count): return "\(count) ASSETS"
        }
    }
    
    var textColor: Color {
        switch self {
        case .live: return .white
        case .draft: return .white
        case .archived: return .white.opacity(0.7)
        case .assets: return .white
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .live: return Color.pink
        case .draft: return Color.gray.opacity(0.5)
        case .archived: return Color.gray.opacity(0.3)
        case .assets: return Color.teal.opacity(0.8)
        }
    }
}

// MARK: - Preview
#Preview {
    CampaignListView()
}
